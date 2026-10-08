// Bundled legacy menus; official command identifiers and user preferences stay independent.
#include "praatP.h"
#include "praat_chinese.h"
#include <filesystem>
#if defined (_WIN32)
#include <windows.h>
#include <shellapi.h>
#endif

#include "praatM.h"
#include "Spectrum.h"
#include "Sound.h"
#include "PitchTier.h"
#include "PitchTier_to_Sound.h"
#include <cmath>

FORM (QUERY_legacyPower, U"Spectrum power density", nullptr) {
    NATURAL (bin, U"Bin number", U"1")
    OK
DO
    QUERY_ONE_FOR_REAL (Spectrum)
        Melder_require (bin <= my nx, U"Bin number exceeds the spectrum size.");
        const double result = my v_getValueAtSample (bin, 0, 2);
    QUERY_ONE_FOR_REAL_END (U" dB/Hz")
}
DIRECT (MODIFY_legacyZero) {
    MODIFY_EACH (Spectrum)
        my z[1][1] = my z[2][1] = 0.0;
    MODIFY_EACH_END
}
FORM (QUERY_legacyAmplitude, U"Convert amplitude to 16-bit scale", nullptr) {
    REAL (amplitude, U"Amplitude", U"0.5")
    OK
DO
    QUERY_GRAPHICS_FOR_REAL
        const double result = amplitude * 32768.0;
    QUERY_GRAPHICS_FOR_REAL_END (U"")
}
FORM (INFO_legacyEnergy, U"Energy distribution", nullptr) {
    REAL (x2, U"Band 2 (dB)", U"0.0")
    REAL (x3, U"Band 3 (dB)", U"0.0")
    REAL (x4, U"Band 4 (dB)", U"0.0")
    REAL (x5, U"Band 5 (dB)", U"0.0")
    REAL (x6, U"Band 6 (dB)", U"0.0")
    REAL (x7, U"Band 7 (dB)", U"0.0")
    REAL (x8, U"Band 8 (dB)", U"0.0")
    REAL (x9, U"Band 9 (dB)", U"0.0")
    REAL (x10, U"Band 10 (dB)", U"0.0")
    REAL (x11, U"Band 11 (dB)", U"0.0")
    REAL (x12, U"Band 12 (dB)", U"0.0")
    REAL (x13, U"Band 13 (dB)", U"0.0")
    REAL (x14, U"Band 14 (dB)", U"0.0")
    REAL (x15, U"Band 15 (dB)", U"0.0")
    REAL (x16, U"Band 16 (dB)", U"0.0")
    REAL (x17, U"Band 17 (dB)", U"0.0")
    REAL (x18, U"Band 18 (dB)", U"0.0")
    REAL (x19, U"Band 19 (dB)", U"0.0")
    REAL (x20, U"Band 20 (dB)", U"0.0")
    REAL (x21, U"Band 21 (dB)", U"0.0")
    REAL (x22, U"Band 22 (dB)", U"0.0")
    REAL (x23, U"Band 23 (dB)", U"0.0")
    REAL (x24, U"Band 24 (dB)", U"0.0")
    OK
DO
    INFO_NONE
        const double db[] = {x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24};
        double maximum = db[0];
        for (double v : db) maximum = std::max(maximum,v);
        double sum = 0, first = 0, second = 0;
        for (int i=0; i<23; ++i) {
            double w = pow(10.0,(db[i]-maximum)/10.0), b = i+2.0;
            sum += w; first += w*b; second += w*b*b;
        }
        const double mean = first/sum;
        const double sd = sqrt(std::max(0.0,second/sum-mean*mean));
        MelderInfo_open();
        MelderInfo_write(Melder_fixed(mean,2),U"\t",Melder_fixed(sd,2));
        MelderInfo_close();
    INFO_NONE_END
}
FORM (QUERY_legacySkewness, U"Bei 计算偏度", nullptr) {
    REAL (n, U"Sample size", U"10")
    REAL (x2, U"Sum of squared deviations", U"20")
    REAL (x3, U"Sum of cubed deviations", U"30")
    OK
DO
    QUERY_GRAPHICS_FOR_REAL
        Melder_require (n > 2 && x2 > 0, U"Invalid parameters for legacy calculation.");
        const double result = n*sqrt(n-1)/(n-2)*x3/pow(x2,1.5);
    QUERY_GRAPHICS_FOR_REAL_END (U"")
}
FORM (QUERY_legacyKurtosis, U"Bei 计算峰度", nullptr) {
    REAL (n, U"Sample size", U"10")
    REAL (x2, U"Sum of squared deviations", U"20")
    REAL (x4, U"Sum of fourth-power deviations", U"30")
    OK
DO
    QUERY_GRAPHICS_FOR_REAL
        Melder_require (n > 3 && x2 > 0, U"Invalid parameters for legacy calculation.");
        const double result = n*(n+1)*(n-1)/((n-2)*(n-3))*x4/(x2*x2)-3*(n-1)*(n-1)/((n-2)*(n-3));
    QUERY_GRAPHICS_FOR_REAL_END (U"")
}
FORM (QUERY_legacySkewnessSE, U"Bei 计算偏度的标准误", nullptr) {
    REAL (n, U"Sample size", U"10")
    OK
DO
    QUERY_GRAPHICS_FOR_REAL
        Melder_require (n > 2, U"Invalid parameters for legacy calculation.");
        const double result = sqrt(6*n*(n-1)/((n-2)*(n+1)*(n+3)));
    QUERY_GRAPHICS_FOR_REAL_END (U"")
}
FORM (QUERY_legacyKurtosisSE, U"Bei 计算峰度的标准误", nullptr) {
    REAL (n, U"Sample size", U"10")
    OK
DO
    QUERY_GRAPHICS_FOR_REAL
        Melder_require (n > 3, U"Invalid parameters for legacy calculation.");
        const double result = sqrt(24*n*(n-1)*(n-1)/((n-3)*(n-2)*(n+3)*(n+5)));
    QUERY_GRAPHICS_FOR_REAL_END (U"")
}
FORM (QUERY_legacyJarqueBera, U"Bei 计算Jarque-Bera值", nullptr) {
    REAL (n, U"Sample size", U"10")
    REAL (skewness, U"Skewness", U"0")
    REAL (kurtosis, U"Excess kurtosis", U"0")
    OK
DO
    QUERY_GRAPHICS_FOR_REAL
        Melder_require (n > 0, U"Invalid parameters for legacy calculation.");
        const double result = n/6.0*(skewness*skewness+kurtosis*kurtosis/4.0);
    QUERY_GRAPHICS_FOR_REAL_END (U"")
}
FORM (QUERY_legacySemitones, U"Bei 根据赫兹按指定参考频率求半音", nullptr) {
    REAL (hz, U"Frequency (Hz)", U"200")
    REAL (reference, U"Reference frequency (Hz)", U"100")
    OK
DO
    QUERY_GRAPHICS_FOR_REAL
        Melder_require (hz > 0 && reference > 0, U"Invalid parameters for legacy calculation.");
        const double result = 12*log2(hz/reference);
    QUERY_GRAPHICS_FOR_REAL_END (U"")
}
FORM (QUERY_legacyHertz, U"Bei 根据半音按指定参考频率求赫兹", nullptr) {
    REAL (semitones, U"Semitones", U"12")
    REAL (reference, U"Reference frequency (Hz)", U"100")
    OK
DO
    QUERY_GRAPHICS_FOR_REAL
        Melder_require (reference > 0, U"Invalid parameters for legacy calculation.");
        const double result = reference*pow(2.0,semitones/12.0);
    QUERY_GRAPHICS_FOR_REAL_END (U"")
}

static void praat_chinese_registerCommands () {
    praat_addAction1 (classSpectrum,1,U"Bei 功率谱分贝值...",nullptr,GuiMenu_HIDDEN,QUERY_legacyPower);
    praat_addAction1 (classSpectrum,1,U"Bei 修改0",nullptr,GuiMenu_HIDDEN,MODIFY_legacyZero);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 幅度积3...",nullptr,GuiMenu_HIDDEN,QUERY_legacyAmplitude);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 计算能量分布模式...",nullptr,GuiMenu_HIDDEN,INFO_legacyEnergy);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 计算偏度...",nullptr,GuiMenu_HIDDEN,QUERY_legacySkewness);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 计算峰度...",nullptr,GuiMenu_HIDDEN,QUERY_legacyKurtosis);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 计算偏度的标准误...",nullptr,GuiMenu_HIDDEN,QUERY_legacySkewnessSE);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 计算峰度的标准误...",nullptr,GuiMenu_HIDDEN,QUERY_legacyKurtosisSE);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 计算Jarque-Bera值...",nullptr,GuiMenu_HIDDEN,QUERY_legacyJarqueBera);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 根据赫兹按指定参考频率求半音...",nullptr,GuiMenu_HIDDEN,QUERY_legacySemitones);
    praat_addMenuCommand(U"Objects",U"Goodies",U"Bei 根据半音按指定参考频率求赫兹...",nullptr,GuiMenu_HIDDEN,QUERY_legacyHertz);
}

static std::u32string applicationDirectory;
const char32_t * praat_chineseDirectory () { return applicationDirectory.c_str(); }
void praat_chinese_init () {
    std::filesystem::path folder;
    #if defined (_WIN32)
        wchar_t executable [32768];
        DWORD n = GetModuleFileNameW (nullptr, executable, 32768);
        Melder_require (n > 0 && n < 32768, U"Cannot locate the bundled scripts.");
        folder = std::filesystem::path(executable).parent_path();
    #else
        folder = std::filesystem::path(Melder_peek32to8(Melder_getShellDirectory()));
    #endif
    auto base = folder.u32string();
    applicationDirectory = base;
    praat_chinese_registerCommands ();
    if (! std::filesystem::is_directory(folder / "assets" / "legacy")) return;
    auto data = std::filesystem::path(std::u32string(MelderFolder_peekPath(Melder_preferencesFolder()))) / "data";
    std::filesystem::create_directories(data);
    if (std::filesystem::is_directory(folder / "assets" / "data"))
        for (const auto &entry : std::filesystem::directory_iterator(folder / "assets" / "data"))
            if (entry.is_regular_file()) std::filesystem::copy_file(entry.path(),data/entry.path().filename(),std::filesystem::copy_options::skip_existing);
    praat_addMenuCommand (U"Objects",U"Praat",U"辅音",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"元音",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"声调",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"语调",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"语音听辨",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"语音标注",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"音系整理",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"查询检索",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"数值计算",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"其他功能",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommand (U"Objects",U"Praat",U"视频处理",nullptr,GuiMenu_UNHIDABLE,nullptr);
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 绘制频谱图（带临界坐标刻度）",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/am.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 塞音时长统计与画图",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/cd.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 频带能量统计与画图",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/af.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 能量分布模式统计与画图",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/ar.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 塞擦音时长和能量分布模式统计与画图",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/cg.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 单独画某辅音的频带能量曲线",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/bq.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 单独画某辅音的能量分布模式",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/br.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 单独画某塞擦音",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/ch.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 多人塞音时长值平均与画图",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/ce.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 多人频带能量值平均与画图",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/bt.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 多人能量分布模式平均与画图",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/bv.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 多人塞擦音时长和能量分布统计与画图",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/ci.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 根据energy文件自动标注声音文件的辅音信息",U"辅音",1,Melder_cat (base.c_str(),U"/assets/legacy/da.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 元音统计与画图",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/d.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 单独画某元音",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/f.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei V值图中画箭头",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/o.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 多人V值平均与画图",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/t.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 多人V值表画椭圆图",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/aa.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 绘制声学元音散点图",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/bb.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 元音统计与画图（lgHz or Bark标度）",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/be.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 绘制标准普通话单元音V值图",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/bz.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 根据vowel文件自动标注声音文件的元音信息",U"元音",1,Melder_cat (base.c_str(),U"/assets/legacy/db.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 声调统计与画图(相对时长)",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/c.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 声调统计与画图(绝对时长)",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/l.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 单独画某调类",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/e.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 多人T值平均与画图",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/s.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 双字调画图",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/bd.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 三字调画图",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/dm.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 声调时长统计与画图",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/i.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 绘制标准普通话单字调T值图",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/by.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 根据tone文件自动标注声音文件的声调信息",U"声调",1,Melder_cat (base.c_str(),U"/assets/legacy/dc.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 语调画图",U"语调",1,Melder_cat (base.c_str(),U"/assets/legacy/j.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 起伏度统计与画图",U"语调",1,Melder_cat (base.c_str(),U"/assets/legacy/r.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 单独画某句起伏度",U"语调",1,Melder_cat (base.c_str(),U"/assets/legacy/v.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 多人起伏度值平均与画图",U"语调",1,Melder_cat (base.c_str(),U"/assets/legacy/bu.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 听辨实验数据收集",U"语音听辨",1,Melder_cat (base.c_str(),U"/assets/legacy/bf.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 提取标注内容和指定声学参数",U"语音标注",1,Melder_cat (base.c_str(),U"/assets/legacy/ab.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 整理同音字表",U"音系整理",1,Melder_cat (base.c_str(),U"/assets/legacy/as.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 国际音标代码表",U"查询检索",1,Melder_cat (base.c_str(),U"/assets/legacy/ae.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 常用汉字中古音查询",U"查询检索",1,Melder_cat (base.c_str(),U"/assets/legacy/aq.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 判断诗词平仄格式",U"查询检索",1,Melder_cat (base.c_str(),U"/assets/legacy/di.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 古文中古拟音",U"查询检索",1,Melder_cat (base.c_str(),U"/assets/legacy/dj.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 在Table或Strings中查找",U"查询检索",1,Melder_cat (base.c_str(),U"/assets/legacy/bo.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 在Table或Strings中替换",U"查询检索",1,Melder_cat (base.c_str(),U"/assets/legacy/bp.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 根据首列内容检索",U"查询检索",1,Melder_cat (base.c_str(),U"/assets/legacy/bn.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 文本检索",U"查询检索",1,Melder_cat (base.c_str(),U"/assets/legacy/ax.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 指定列数据统计与画图",U"数值计算",1,Melder_cat (base.c_str(),U"/assets/legacy/u.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 根据赫兹求临界频带值",U"数值计算",1,Melder_cat (base.c_str(),U"/assets/legacy/ak.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 根据临界频带值求赫兹范围",U"数值计算",1,Melder_cat (base.c_str(),U"/assets/legacy/al.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 根据赫兹按指定参考频率求半音",U"数值计算",1,Melder_cat (base.c_str(),U"/assets/legacy/an.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 根据半音按指定参考频率求赫兹",U"数值计算",1,Melder_cat (base.c_str(),U"/assets/legacy/ao.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 检查离群值和极端值",U"数值计算",1,Melder_cat (base.c_str(),U"/assets/legacy/ay.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 计算个数、和、最小值、最大值、平均值、标准差、变异系数",U"数值计算",1,Melder_cat (base.c_str(),U"/assets/legacy/az.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 计算偏度、峰度、Jarque-Bera值",U"数值计算",1,Melder_cat (base.c_str(),U"/assets/legacy/ba.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 按调查表格录音",U"其他功能",1,Melder_cat (base.c_str(),U"/assets/legacy/h.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 调整录音音量",U"其他功能",1,Melder_cat (base.c_str(),U"/assets/legacy/de.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 调整播放音量",U"其他功能",1,Melder_cat (base.c_str(),U"/assets/legacy/dd.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 转换音视频文件格式",U"其他功能",1,Melder_cat (base.c_str(),U"/assets/legacy/ca.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 某一列出现乱码问题的显示",U"其他功能",1,Melder_cat (base.c_str(),U"/assets/legacy/bg.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 打开常见的程序",U"其他功能",1,Melder_cat (base.c_str(),U"/assets/legacy/cb.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 打开指定的文件夹",U"其他功能",1,Melder_cat (base.c_str(),U"/assets/legacy/bc.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 播放指定视频",U"视频处理",1,Melder_cat (base.c_str(),U"/assets/legacy/w.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 截取一段视频",U"视频处理",1,Melder_cat (base.c_str(),U"/assets/legacy/x.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 删除视频中的全部音频",U"视频处理",1,Melder_cat (base.c_str(),U"/assets/legacy/y.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 提取视频中的全部音频",U"视频处理",1,Melder_cat (base.c_str(),U"/assets/legacy/z.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 录制屏幕和麦克风",U"视频处理",1,Melder_cat (base.c_str(),U"/assets/legacy/df.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 录制屏幕、声卡和麦克风",U"视频处理",1,Melder_cat (base.c_str(),U"/assets/legacy/dg.praat"));
    praat_addMenuCommandScript (U"Objects",U"Praat",U"Bei 录制摄像头、声卡和麦克风",U"视频处理",1,Melder_cat (base.c_str(),U"/assets/legacy/dh.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Time",U"Bei 测量时长",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/g.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Time",U"Bei 绘制声学图片",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/q.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Spectrogram",U"Bei 测量塞音时长",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/cc.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Spectrogram",U"Bei 测量幅度积",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/p.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Spectrogram",U"Bei 测量频带能量(dB)",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/ag.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Spectrogram",U"Bei 测量辅音能量分布模式",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/aj.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Spectrogram",U"Bei 测量塞擦音时长和能量分布模式",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/cf.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Pitch",U"Bei 根据窄带语图修改基频曲线并测量",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/ah.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Pitch",U"Bei 根据功率谱图修改基频曲线并测量",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/ai.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Pitch",U"Bei 撤销上一步基频数据",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/n.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Pitch",U"Bei 基频曲线显示异常时的参数设置",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/bl.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Pitch",U"Bei 测量基频",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/a.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Formants",U"Bei 向声学元音图中添加元音",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/k.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Formants",U"Bei 撤销上一步共振峰数据",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/m.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Formants",U"Bei 移动光标到共振峰极值处",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/bm.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Formants",U"Bei 测量共振峰",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/b.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Legacy",U"Bei 测量幅度积",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/p.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Legacy",U"Bei 测量频带能量(dB)",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/ag.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Legacy",U"Bei 测量基频",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/a.praat"));
    praat_addMenuCommandScript (U"SoundEditor",U"Legacy",U"Bei 测量共振峰",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/b.praat"));
    praat_addMenuCommandScript (U"PitchEditor",U"Pitch",U"Bei 测量基频",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/ac.praat"));
    praat_addMenuCommandScript (U"PitchTierEditor",U"PitchTier",U"Bei 测量基频",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/ad.praat"));
    praat_addMenuCommandScript (U"TextGridEditor",U"Pitch",U"Bei 测量基频",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/a.praat"));
    praat_addMenuCommandScript (U"TextGridEditor",U"Formants",U"Bei 测量共振峰",U"",0,Melder_cat (base.c_str(),U"/assets/legacy/b.praat"));
}

// Private process-local phonetic font; no system installation or registry writes.
void praat_chinese_loadFonts () {
    #if defined (_WIN32)
        wchar_t executable [32768];
        DWORD n=GetModuleFileNameW(nullptr,executable,32768);
        if(n>0 && n<32768) {
            auto font=std::filesystem::path(executable).parent_path()/"assets"/"fonts"/"DoulosSIL-R.ttf";
            AddFontResourceExW(font.c_str(),FR_PRIVATE,nullptr);
        }
    #endif
}

void praat_chinese_showHtmlAbout () {
    #if defined (_WIN32)
        auto path=std::filesystem::path(applicationDirectory)/"assets"/"about.html";
        if(std::filesystem::exists(path)) ShellExecuteW(nullptr,L"open",path.c_str(),nullptr,nullptr,SW_SHOWNORMAL);
    #endif
}
