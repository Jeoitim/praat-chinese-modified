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
#本脚本的功能是根据C值表绘制指定的某个辅音的频带能量曲线。
#请读入C值表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.05.08

form set parameters
	comment 请读入C值表后再运行本脚本。
	comment 注意：name_of_picture_to_be_saved处为空则不自动保持图片。
	boolean marks 1
	choice color 1
		button random
		button Red
		button Blue
		button Green
		button Black
	sentence consonant s
	sentence name_of_picture_to_be_saved 
endform
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif

endeditor
fileName$ = selected$("Table")
columnLabel1$ = Get column label... 1
columnLabel3$ = Get column label... 3
if columnLabel1$ != "consonant" and columnLabel3$ != "dot2"
	exit 请选择正确的C值表。
endif
Font size... 14
Draw inner box
Axes... 1 20 0 100
if marks = 1
	Marks bottom every... 1 1 yes yes no
	Marks left every... 1 20 yes yes yes
else
	Marks bottom every... 1 1 yes yes no
	Marks left every... 1 20 yes yes no
endif
#numberOfRows = Get number of rows
consonant$ = backslashTrigraphsToUnicode$(consonant$)
numberOfRows = Search column... consonant 'consonant$'
if numberOfRows = 0
	exit 表中不存在指定的辅音，请重新输入。
endif
dotLabelTemp$ = Get column label... 2
cZhiTemp = Get value... 2 'dotLabelTemp$'
cZhiTemp$ = string$(cZhiTemp)
numberOfColumns = Get number of columns
for i from numberOfRows to numberOfRows
	for j from 1 to numberOfColumns - 1
		consonantLabel$ = Get column label... 1
		consonantName$ = Get value... i 'consonantLabel$'
		dotLabel$ = Get column label... j+1
		cZhi = Get value... i 'dotLabel$'
		cZhi$ = string$(cZhi)
		if cZhi$ != "--undefined--"
			if color = 1
				if i = 1 or i = 9
					Red
					symbol$ = "■"
				elsif i = 2 or i = 10
					Green
					symbol$ = "◆"
				elsif i = 3 or i = 11
					Blue
					symbol$ = "▲"
				elsif i = 4 or i = 12
					Black
					symbol$ = "▼"
				elsif i = 5 or i = 13
					Red
					symbol$ = "□"
				elsif i = 6 or i = 14
					Green
					symbol$ = "◇"
				elsif i = 7 or i = 15
					Blue
					symbol$ = "△"
				elsif i = 8 or i = 16
					Black
					symbol$ = "▽"
				else
					symbol$ = "●"
				endif
			elsif color = 2
				Red
				symbol$ = "■"
			elsif color = 3	
				Blue
				symbol$ = "◆" 
			elsif color = 4
				Green
				symbol$ = "▲" 
			elsif color = 5
				Black
				symbol$ = "▼" 
			endif
			#此外，还有symbol$ = "○"等
			Text... j Centre cZhi Half 'symbol$'
			if j = numberOfColumns - 1
				Black
				Text... 20.2 Left cZhi Half 'consonantName$'
			endif
			if cZhiTemp$ = "--undefined--"
				if j >= 3
					labelBeforeOneDot$ = Get column label... j
					cZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
					Black
					Draw line... j-1 cZhiBeforeOneDot j cZhi
				endif
			else
				if j >= 2
					labelBeforeOneDot$ = Get column label... j
					cZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
					Black
					Draw line... j-1 cZhiBeforeOneDot j cZhi
				endif	
			endif
		endif
	endfor
endfor
Font size... 13
Select outer viewport... 0.2 6 0 4
Text bottom... yes Frequency Band
Text left... yes Energy  (C value)
Select outer viewport... 0 6.5 0 4
if name_of_picture_to_be_saved$ != ""
	if windows
	    Save as 600-dpi PNG file: "'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'"
	else
	    Save as PDF file: "'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'"
	endif
endif
Font size... 10
Select outer viewport: 0, 6, 0, 4
#End