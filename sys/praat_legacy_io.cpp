// Historical analysis-table import and explicit text formatting; jeoitim.
// jeoitim; uses Praat's Unicode file decoder and Table implementation.
#include "praat_legacy_io.h"
#include <string>
#include <vector>
#include <memory>
#include <filesystem>

static std::u32string trimmed (std::u32string text) {
    const auto first=text.find_first_not_of(U" \t\r\n\ufeff");
    if(first==std::u32string::npos) return {};
    return text.substr(first,text.find_last_not_of(U" \t\r\n")-first+1);
}
static std::vector<std::u32string> split (const std::u32string &line, bool tabs) {
    std::vector<std::u32string> cells;
    size_t start=0;
    for(size_t i=0;i<=line.size();++i) {
        if(i==line.size() || line[i]==U'\t' || (!tabs && line[i]==U' ')) {
            auto value=trimmed(line.substr(start,i-start));
            if(tabs || !value.empty()) cells.push_back(value);
            start=i+1;
        }
    }
    return cells;
}
autoTable praat_readLegacyTable (MelderFile file, conststring32 headerHint) {
    {
        std::unique_ptr<FILE,decltype(&fclose)> stream(Melder_fopen(file,"rb"),fclose);
        char magic[13] { };
        fread(magic,1,12,stream.get());
        if(strnequ(magic,"ooBinaryFile",12)) {
            stream.reset();
            auto object=Data_readFromFile(file);
            Melder_require(Thing_isa(object.get(),classTable),U"请选择 Table 或测量文本文件。");
            return object.static_cast_move<structTable>();
        }
    }
    auto text=MelderFile_readText(file);
    std::u32string content(text.get());
    if(content.find(U"ooTextFile")!=std::u32string::npos &&
       (content.find(U"Object class = \"Table\"")!=std::u32string::npos || content.find(U"\n\"Table\"")!=std::u32string::npos)) {
        auto object=Data_readFromFile(file);
        Melder_require(Thing_isa(object.get(),classTable),U"请选择 Table 数据。");
        return object.static_cast_move<structTable>();
    }
    std::vector<std::vector<std::u32string>> rows;
    for(size_t start=0;start<content.size();) {
        auto end=content.find_first_of(U"\r\n",start);
        if(end==std::u32string::npos) end=content.size();
        auto line=trimmed(content.substr(start,end-start));
        start=end+1;
        if(line.empty() || line.front()==U'#') continue;
        rows.push_back(split(line,line.find(U'\t')!=std::u32string::npos));
    }
    Melder_require(!rows.empty(),U"分析文件没有数据：",file);
    auto headers=split(std::u32string(headerHint),false);
    const bool hasHeader=rows.front().size()>1 &&
        !Melder_isStringNumeric(rows.front()[1].c_str()) &&
        rows.front()[1]!=U"--undefined--" && rows.front()[1]!=U"undefined";
    std::vector<std::u32string> sourceHeaders;
    if(hasHeader) {
        sourceHeaders=rows.front();
        if(headers.empty()) headers=sourceHeaders;
        rows.erase(rows.begin());
    }
    size_t width=headers.size();
    for(const auto &row:rows) width=std::max(width,row.size());
    while(headers.size()<width) headers.push_back(U"column"+std::u32string(Melder_integer(headers.size()+1)));
    Melder_require(width>0,U"分析文件没有数据列。");
    auto result=Table_createWithoutColumnNames(0,integer(width));
    for(size_t col=0;col<width;++col) {
        auto label=headers[col].empty()?U"column"+std::u32string(Melder_integer(col+1)):headers[col];
        for(size_t previous=0;previous<col;++previous)
            if(label==headers[previous]) label+=U"_"+std::u32string(Melder_integer(col+1));
        Table_renameColumn_e(result.get(),integer(col+1),label.c_str());
    }
    for(const auto &row:rows) {
        if(row==headers || (!sourceHeaders.empty() && row==sourceHeaders)) continue;
        Table_appendRow(result.get());
        for(size_t col=0;col<row.size();++col)
            Table_setStringValue(result.get(),result->rows.size,integer(col+1),row[col].c_str());
    }
    Melder_require(result->rows.size>0,U"分析文件只有表头，没有测量数据。");
    return result;
}

// Preserve the supplied scripts' preparation step: spaces become tabs and
// consecutive separators collapse. Native Praat objects must never be rewritten.
void praat_formatLegacyText (MelderFile file) {
    {
        std::unique_ptr<FILE,decltype(&fclose)> stream(Melder_fopen(file,"rb"),fclose);
        char magic[13] { };
        fread(magic,1,12,stream.get());
        if(strnequ(magic,"ooBinaryFile",12)) return;
    }
    auto text=MelderFile_readText(file);
    const std::u32string content(text.get());
    if(content.find(U"ooTextFile")!=std::u32string::npos &&
       (content.find(U"Object class = \"Table\"")!=std::u32string::npos || content.find(U"\n\"Table\"")!=std::u32string::npos)) return;
    std::u32string formatted;
    for(size_t start=0;start<content.size();) {
        size_t end=content.find_first_of(U"\r\n",start);
        if(end==std::u32string::npos) end=content.size();
        size_t next=end;
        if(next<content.size() && content[next]==U'\r') ++next;
        if(next<content.size() && content[next]==U'\n') ++next;
        const auto cells=split(content.substr(start,end-start),false);
        if(!cells.empty()) {
            for(size_t i=0;i<cells.size();++i) {
                if(i) formatted+=U'\t';
                formatted+=cells[i];
            }
            formatted+=content.substr(end,next-end);
        }
        start=next;
    }
    Melder_require(!formatted.empty(),U"分析文件没有数据：",file);
    if(formatted==content) return;
    // An exact-byte backup also preserves the original encoding. Never overwrite
    // a previous backup, including a backup from an earlier formatting run.
    const std::filesystem::path source(file->path);
    auto backup=source;
    backup+=U".before-tabs.bak";
    for(integer serial=1;std::filesystem::exists(backup);++serial) {
        backup=source;
        backup+=std::u32string(U".before-tabs.")+Melder_integer(serial)+U".bak";
    }
    try {
        std::filesystem::copy_file(source,backup);
    } catch (const std::exception &error) {
        Melder_throw(U"无法备份分析文件，原文件尚未改写：",file,U"\n",Melder_peek8to32_u(error.what()));
    }
    MelderFile_writeText_e(file,formatted.c_str(),kMelder_textOutputEncoding::UTF8);
}
