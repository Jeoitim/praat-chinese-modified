# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据共振峰Table表，绘制声学元音散点图。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2020.04.01

form set parameters
	choice is_column_label_existed 1
		button no
		button yes
	boolean erase_all 1
	choice type_of_picture 2
		button F1(Hz)_F2(log(Hz))
		button F1(Bark)_F2(Bark)
	sentence name_of_picture_to_be_saved 声学元音散点图
endform
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif

endeditor
pathFileName$ = chooseReadFile$: "请选择vowel文件"
if pathFileName$ = ""
    exitScript: "已取消。"
endif
Modified read analysis table: pathFileName$, ""

fileName$ = selected$("Table")
x2 = Get number of columns
if x2 > 4
repeat
x2 = Get number of columns
x1$ = Get column label... x2
Remove column... 'x1$'
until x2 = 5
endif

numberOfColumns = Get number of columns
if is_column_label_existed = 1
		for i from 1 to numberOfColumns
		columnLabelTemp$ = Get column label... i
		if i = 1
			Set column label (label)... 'columnLabelTemp$' vowel
		elsif i > 1
			j = i - 1
			Set column label (label)... 'columnLabelTemp$' F'j'
		endif
	endfor
endif

if erase_all = 1
	Erase all
endif
if type_of_picture = 1
	Axes: 3500, 500, 1000, 200
Draw inner box
Text left: "yes", "F1 (Hz)"
Text bottom: "yes", "F2 (Hz)"
elsif type_of_picture = 2
	Axes: hertzToBark(3500), hertzToBark(500), hertzToBark(1000), hertzToBark(200)
Draw inner box
Text left: "yes", "F1 (Bark)"
Text bottom: "yes", "F2 (Bark)"
endif
fileName$ = selected$("Table")
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	ipa$ = Get value... i vowel
	f1 = Get value... i F1
	f2 = Get value... i F2
	if type_of_picture = 1
		Text special... log10(f2) Centre 'f1' Half Times 12 0 'ipa$'
	elsif type_of_picture = 2
		Text special... hertzToBark(f2) Centre hertzToBark(f1) Half Times 12 0 'ipa$'
	endif
endfor
createDirectory: legacyDataDirectory$
i=fileReadable("'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'")
if i = 1
pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if windows
    Save as 600-dpi PNG file... 'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'
else
    Save as PDF file... 'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'
endif
#Remove Table 'fileName$'
