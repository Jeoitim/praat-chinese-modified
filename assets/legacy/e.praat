legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据T值表绘制指定的某个声调的曲线。
#请读入T值表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.02.24

form set parameters
	comment 请读入T值表后再运行本脚本。
	comment 注意：name_of_picture_to_be_saved处为空则不自动保持图片。
	boolean marks 1
	choice color 1
		button random
		button Red
		button Blue
		button Green
		button Black
	sentence tone yinping
	sentence name_of_picture_to_be_saved 
endform
columnLabel$ = Get column label... 3
maximum = Get maximum... 'columnLabel$'
if maximum > 100
exit 请选择正确的T值表。
endif
Select outer viewport: 0, 6, 0, 4
Font size... 14
Draw inner box
Axes... 1 9 0 5
Marks bottom every... 1 1 yes yes no
Marks left every... 1 1 yes yes no
if marks = 1
Marks left... 6 no yes yes
endif
#numberOfRows = Get number of rows
numberOfRows = Search column... tone 'tone$'
if numberOfRows = 0
exit 表中不存在指定的声调，请重新输入。
endif
numberOfColumns = Get number of columns
for i from numberOfRows to numberOfRows
for j from 1 to numberOfColumns - 1
toneLabel$ = Get column label... 1
toneName$ = Get value... i 'toneLabel$'
dotLabel$ = Get column label... j+1
tZhi = Get value... i 'dotLabel$'
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
Text... j Centre tZhi Half 'symbol$'
if j = 10-1
Black
Text... 9.2 Left tZhi Half 'toneName$'
endif
if j >= 2
labelBeforeOneDot$ = Get column label... j
tZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
Black
Draw line... j-1 tZhiBeforeOneDot j tZhi
endif
endfor
endfor
Font size... 13
Select outer viewport... 0.4 6 0 4
Text bottom... yes Time (normalized)
Text left... yes Pitch (T value)
Select outer viewport... 0 6.5 0 4
if name_of_picture_to_be_saved$ != ""
	Save as Windows metafile: "'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf"
endif
Font size... 10
Select outer viewport: 0, 6, 0, 4