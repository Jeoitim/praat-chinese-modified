# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是提取纯汉字、纯阿拉伯数字或英文。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.03.10

form set parameters
	choice type 1
		button 只保留汉字
		button 只保留阿拉伯数字
		button 只保留英文
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
for inumberOfStrings to numberOfStrings
	string$ = Get string: inumberOfStrings
	length = length(string$)
	for ilength to length
		text$ = mid$(string$, ilength, 1)
		unicode = unicode(text$)
		if type = 1
			if unicode < 19968 or unicode > 40869
				string$ = replace$(string$, text$, " ", 1)
			endif
		elsif type = 2
			if unicode < 48 or unicode > 57
				string$ = replace$(string$, text$, " ", 1)
			endif
		elsif type = 3
			if unicode < 65 or unicode > 122 or unicode > 90 and unicode < 97
				string$ = replace$(string$, text$, " ", 1)
			endif
		endif
	endfor
	repeat
		string$ = replace$(string$, "  ", " ", 0)
	until index(string$, "  ") = 0
	Set string: inumberOfStrings, string$
endfor
if type = 1
	fileNameTemp$ = fileName$+"_保留纯汉字"
elsif type = 2
	fileNameTemp$ = fileName$+"_保留阿拉伯数字"
elsif type = 3
	fileNameTemp$ = fileName$+"_保留英文"
endif
numberOfStrings = Get number of strings
for inumberOfStrings to numberOfStrings
	string$ = Get string: inumberOfStrings
	if string$ = "" or string$ = " " or string$ = "	"
		Remove string: inumberOfStrings
		inumberOfStrings -= 1
		numberOfStrings -= 1
	endif
endfor
if type = 1
    suffix$ = "_保留纯汉字"
elsif type = 2
    suffix$ = "_保留阿拉伯数字"
else
    suffix$ = "_保留英文"
endif
slash = max(rindex(fileNameStrings$, "/"), rindex(fileNameStrings$, "\"))
inputBase$ = right$(fileNameStrings$, length(fileNameStrings$) - slash)
dot = rindex(inputBase$, ".")
if dot > 0
    inputBase$ = left$(inputBase$, dot - 1)
endif
outputPath$ = legacyDataDirectory$ + "/" + inputBase$
outputPath$ = outputPath$ + suffix$ + ".txt"
if fileReadable(outputPath$)
    exitScript: "结果文件已存在，请先移走或使用新的输入文件名：", outputPath$
endif
Save as raw text file: outputPath$
appendInfoLine: "完成！请查看", outputPath$