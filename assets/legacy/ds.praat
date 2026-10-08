legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是统计字频。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.03.10

form set parameters
	comment 注意：待分析的文件名不要有空格、括号等
	choice type 1
	button 只包括汉字
	button 包括所有字符
endform

fileNameStrings$ = chooseReadFile$: "请选择需要处理的文件"
if fileNameStrings$ <> ""
 	Read Strings from raw text file... 'fileNameStrings$'
endif
if fileNameStrings$ = ""
    exitScript: "已取消。"
endif
fileName$ = selected$("Strings")
numberOfStrings = Get number of strings
Create Table with column names... 字频 0 字 频率

if type = 1
for i to numberOfStrings
	select Strings 'fileName$'
	strings$ = Get string... i
	length = length(strings$)
	for j from 1 to length
		value$ = mid$(strings$,j,1)
		unicode = unicode(value$)
		if unicode >= 19968 and unicode <= 40869
			select Table 字频
			searchColumn = Search column... 字 'value$'
			if searchColumn = 0
				select Table 字频
				Append row
				rows = Get number of rows
				Set string value... rows 字 'value$'
				Set numeric value... rows 频率 1
			elsif searchColumn <> 0
				select Table 字频
				number = Get value... searchColumn 频率
				Set numeric value... searchColumn 频率 'number'+1
			endif
		endif
	endfor
endfor
elsif type = 2
for i to numberOfStrings
	select Strings 'fileName$'
	strings$ = Get string... i
	length = length(strings$)
	for j from 1 to length
		value$ = mid$(strings$,j,1)
		select Table 字频
		searchColumn = Search column... 字 'value$'
		if searchColumn = 0
			select Table 字频
			Append row
			rows = Get number of rows
			Set string value... rows 字 'value$'
			Set numeric value... rows 频率 1
		elsif searchColumn <> 0
			select Table 字频
			number = Get value... searchColumn 频率
			Set numeric value... searchColumn 频率 'number'+1
		endif
	endfor
endfor
endif
select Table 字频
Sort rows... 频率
nocheck Reflect rows
numberOfRows = Get number of rows
sum = 0
for i to numberOfRows
	value = Get value... i 频率
	sum = sum + value
endfor
Append column... 百分比
for i to numberOfRows
	value = Get value... i 频率
	percent = value / sum * 100
	percent$ = "'percent'"
	percent$ = left$ (percent$, 8)
	Set string value... i 百分比 'percent$'%
endfor
suffix$ = "_字频"
dot = rindex(fileNameStrings$, ".")
slash = max(rindex(fileNameStrings$, "/"), rindex(fileNameStrings$, "\"))
if dot > slash
    outputPath$ = left$(fileNameStrings$, dot - 1)
else
    outputPath$ = fileNameStrings$
endif
outputPath$ = outputPath$ + suffix$ + ".tsv"
if fileReadable(outputPath$)
    exitScript: "结果文件已存在，请先移走或使用新的输入文件名：", outputPath$
endif
Save as tab-separated file: outputPath$
appendInfoLine: "完成，共统计", sum, "个字。请查看", outputPath$
