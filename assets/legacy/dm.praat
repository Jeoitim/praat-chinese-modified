legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据T值绘制指定的三字调的曲线。
#请读入T值表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2024.05.25

form set parameters
	comment 请读入T值表后再运行本脚本。
	comment first-third syllable分别是前字、中字、后字的调类标法。
	comment name of first-third syllable in picture是前字、中字、后字在图中的新名称（空格则无）。
	boolean marks 1
	boolean erase_all 1
	choice color 1
		button Red
		button Blue
		button Green
		button Black
	sentence first_syllable 11-1
	sentence second_syllable 11-2
	sentence third_syllable 11-3
	sentence name_of_first_syllable_in_picture 
	sentence name_of_second_syllable_in_picture 
	sentence name_of_third_syllable_in_picture 
	sentence name_of_picture_to_be_saved 三字调T值图(相对时长)
endform
fileName$ = selected$("Table")
columnLabel$ = Get column label... 3
maximum = Get maximum... 'columnLabel$'
if maximum > 50
	exit 请选择正确的T值表。
endif
if erase_all = 1
	Erase all
endif
Font size... 12
Select outer viewport... 0 6 0 4
Draw inner box
Axes... 1 29 0 5
Marks bottom every... 1 1 yes yes no
Marks left every... 1 1 yes yes no
if marks = 1
	Marks left... 6 no yes yes
endif
numberOfRows = Get number of rows

numberOfRows = Search column... tone 'first_syllable$'
if numberOfRows = 0
	exit 表中不存在指定的声调，请重新输入。
endif
numberOfColumns = Get number of columns
Select outer viewport... 0 6 0 4
for i from numberOfRows to numberOfRows
	for j from 1 to numberOfColumns - 1
		toneLabel$ = Get column label... 1
		toneName$ = Get value... i 'toneLabel$'
		dotLabel$ = Get column label... j+1
		tZhi = Get value... i 'dotLabel$'
		if color = 1
			Red
			symbol$ = "■"
		elsif color = 2	
			Blue
			symbol$ = "◆" 
		elsif color = 3
			Green
			symbol$ = "▲" 
		elsif color = 4
			Black
			symbol$ = "▼" 
		endif
		Text... j Centre tZhi Half 'symbol$'
		if j = 10-1
			Black
			if name_of_first_syllable_in_picture$ != ""
				Text... 9.3 Left tZhi Half 'name_of_first_syllable_in_picture$'
			else
				Text... 9.3 Left tZhi Half 'first_syllable$'
			endif
		endif
		if j >= 2
			labelBeforeOneDot$ = Get column label... j
			tZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
			Black
			Draw line... j-1 tZhiBeforeOneDot j tZhi
		endif
	endfor
endfor

Select outer viewport... 1.65 7.65 0 4
numberOfRows = Search column... tone 'second_syllable$'
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
			Red
			symbol$ = "■"
		elsif color = 2	
			Blue
			symbol$ = "◆" 
		elsif color = 3
			Green
			symbol$ = "▲" 
		elsif color = 4
			Black
			symbol$ = "▼" 
		endif
		Text... j Centre tZhi Half 'symbol$'
		if j = 10-1
			Black
			if name_of_second_syllable_in_picture$ != ""
				Text... 9.3 Left tZhi Half 'name_of_second_syllable_in_picture$'
			else
				Text... 9.3 Left tZhi Half 'second_syllable$'
			endif
		endif
		if j >= 2
			labelBeforeOneDot$ = Get column label... j
			tZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
			Black
			Draw line... j-1 tZhiBeforeOneDot j tZhi
		endif
	endfor
endfor


Select outer viewport... 3.3 9.3 0 4
numberOfRows = Search column... tone 'third_syllable$'
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
			Red
			symbol$ = "■"
		elsif color = 2	
			Blue
			symbol$ = "◆" 
		elsif color = 3
			Green
			symbol$ = "▲" 
		elsif color = 4
			Black
			symbol$ = "▼" 
		endif
		Text... j Centre tZhi Half 'symbol$'
		if j = 10-1
			Black
			if name_of_second_syllable_in_picture$ != ""
				Text... 9.3 Left tZhi Half 'name_of_second_syllable_in_picture$'
			else
				Text... 9.3 Left tZhi Half 'second_syllable$'
			endif
		endif
		if j >= 2
			labelBeforeOneDot$ = Get column label... j
			tZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
			Black
			Draw line... j-1 tZhiBeforeOneDot j tZhi
		endif
	endfor
endfor

Font size... 12
Select outer viewport... 0.3 6 0 4
Text bottom... yes Time (normalized)
Text left... yes Pitch (T value)
Font size... 10
Select outer viewport... 0 6 0 4
createDirectory: legacyDataDirectory$
i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf")
if i = 1
pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf
Select outer viewport: 0, 6, 0, 4
select Table 'fileName$'
Remove
#END
