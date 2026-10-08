if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对频带能量数据进行归一化，得到C值，同时根据C值绘制声调C值图。并将C值数据和C值图自动保存到软件所在文件夹下的data下。
#请读入energy.txt后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.03.06

form set parameters
	boolean integer_for_results 1
	boolean marks 1
	choice color 1
	button random
	button Red
	button Blue
	button Green
	button Black
	sentence name_of_file_to_be_saved C值表
	sentence name_of_picture_to_be_saved C值图
endform

endeditor
pathFileName$ = chooseReadFile$: "请选择energy文件"
if pathFileName$ != ""
	Read Strings from raw text file: pathFileName$
	numberOfStrings = Get number of strings
	for i from 1 to numberOfStrings
		string$ = Get string: i
		if string$ = "" or string$ = " " or string$ = "	"
			Remove string: i
			numberOfStrings = numberOfStrings - 1
		endif
	endfor
	Save as raw text file: pathFileName$
	Remove
endif
fileReadable = fileReadable(pathFileName$)
if fileReadable = 1
	Read from file: pathFileName$
else
	exit 没有选择文件或文件数据格式有问题。
endif

fileName$ = selected$("Table")
columnLabel1$ = Get column label: 1
columnLabel2$ = Get column label: 23
columnLabel3$ = columnLabel2$ + columnLabel2$ 
if columnLabel1$ = columnLabel2$
	Set column label (index): 23, columnLabel3$
endif

x2 = Get number of columns
if x2 > 21
repeat
x2 = Get number of columns
x1$ = Get column label... x2
Remove column... 'x1$'
until x2 = 22
endif
temp$ = Get column label... 2
Insert row... 1
columnOfNumber = Get number of columns
for i from 1 to columnOfNumber
	column_label_temp$ = Get column label... i
	if i = 1
		Set string value... 1 'column_label_temp$' 'column_label_temp$'
	elsif i > 1
		if column_label_temp$ = ""
			Set string value... 1 'column_label_temp$' 'column_label_temp$'
		else
			Set numeric value... 1 'column_label_temp$' 'column_label_temp$'
		endif
	endif
	if i = 1
		Set column label (label)... 'column_label_temp$' consonant
	elsif i > 1
		j = i - 1
		if column_label_temp$ = ""
			Set column label (index)... 2 dot'j'
		else
			Set column label (label)... 'column_label_temp$' dot'j'
		endif
	endif
endfor
fileName$ = selected$("Table")
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	label$ = Get value... i consonant
		if label$ = "consonant"
		Remove row... i
		numberOfRows = numberOfRows -1
	endif
endfor
numberOfColumns = Get number of columns
invalid = 0
for rows from 1 to numberOfRows
	for columns from 3 to numberOfColumns
		columnLabel$ = Get column label... 'columns'
		value = Get value... 'rows' 'columnLabel$'
		y = value * 0
		y$ = "'y'"
		if y$ = "--undefined--"
			invalid = invalid + 1
		endif
	endfor
endfor
if invalid != 0
	exit 文件中应该为数值数据的地方有'invalid'个非数值数据，文件疑被人为修改过或非本软件生成！请先处理。
endif

numberOfColumns = columnOfNumber
columnLabelFirst$ = Get column label... 1
Sort rows... 'columnLabelFirst$'
Create Table with column names... newTable 0 'columnLabelFirst$'
for h from 1 to numberOfColumns
	if h >= 2
		select Table 'fileName$'
		columnLabel$ = Get column label... h
		select Table newTable
		Append column... 'columnLabel$'
	endif
endfor
select Table 'fileName$'
numberOfRows = Get number of rows
numberOfPhonemes = 0
for i from 1 to numberOfRows
	select Table 'fileName$'
	nameOfPhonemes$ = Get value... i 'columnLabelFirst$'
	if i = 1
		numberOfPhonemes = numberOfPhonemes + 1
		x$ = nameOfPhonemes$
		select Table newTable
		Append row
		Set string value... numberOfPhonemes 'columnLabelFirst$' 'x$'
		select Table 'fileName$'
		numberOfColumns = columnOfNumber
		numberOfDots = numberOfColumns
		if temp$ != ""
			for j from 2 to numberOfDots
				select Table 'fileName$'
				labelOfColumns$ = Get column label... j
				xMeanOfDot = Get group mean... 'labelOfColumns$' 'columnLabelFirst$' 'x$'
				columnLabelNew$ = Get column label... j
				select Table newTable
				Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
			endfor
		elsif temp$ = ""
			for j from 3 to numberOfDots
				select Table 'fileName$'
				labelOfColumns$ = Get column label... j
				xMeanOfDot = Get group mean... 'labelOfColumns$' 'columnLabelFirst$' 'x$'
				columnLabelNew$ = Get column label... j
				select Table newTable
				Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
			endfor
		endif
	elsif i != 1
		if nameOfPhonemes$ != x$
			numberOfPhonemes = numberOfPhonemes + 1
			x$ = nameOfPhonemes$
			select Table newTable
			Append row
			Set string value... numberOfPhonemes 'columnLabelFirst$' 'x$'
			select Table 'fileName$'
			numberOfColumns = columnOfNumber
			numberOfDots = numberOfColumns
			if temp$ != ""
				for j from 2 to numberOfDots
					select Table 'fileName$'
					labelOfColumns$ = Get column label... j
					xMeanOfDot = Get group mean... 'labelOfColumns$' 'columnLabelFirst$' 'x$'
					columnLabelNew$ = Get column label... j
					select Table newTable
					Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
				endfor
			elsif temp$ = ""
				for j from 3 to numberOfDots
					select Table 'fileName$'
					labelOfColumns$ = Get column label... j
					xMeanOfDot = Get group mean... 'labelOfColumns$' 'columnLabelFirst$' 'x$'
					columnLabelNew$ = Get column label... j
					select Table newTable
					Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
				endfor
			endif
		endif
	endif
endfor
for h from 1 to numberOfColumns
	if temp$ != ""
		if h >= 2
			select Table newTable
			columnLabel$ = Get column label... h
			minNew = Get minimum... 'columnLabel$'
			if h = 2
				min = minNew
			endif
			if min > minNew
				min = minNew
			endif
			maxNew = Get maximum... 'columnLabel$'
			if h = 2
				max = maxNew
			endif
			if max < maxNew
				max = maxNew
			endif
		endif
	elsif temp$ = ""
		if h >= 3
			select Table newTable
			columnLabel$ = Get column label... h
			minNew = Get minimum... 'columnLabel$'
			if h = 3
				min = minNew
			endif
			if min > minNew
				min = minNew
			endif
			maxNew = Get maximum... 'columnLabel$'
			if h = 3
				max = maxNew
			endif
			if max < maxNew
				max = maxNew
			endif
		endif
	endif
endfor

clearinfo
numberOfColumns = columnOfNumber 
for h from 1 to numberOfColumns
	if temp$ != ""
		if h >= 2
			columnLabel$ = Get column label... h
			Formula... 'columnLabel$' (self-'min')/('max'-'min')*100
		endif
	elsif temp$ = ""
		if h >= 3
			columnLabel$ = Get column label... h
			Formula... 'columnLabel$' (self-'min')/('max'-'min')*100
		endif
	endif
endfor

Erase all
Select outer viewport: 0, 6, 0, 4
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
numberOfRows = Get number of rows
numberOfColumns = columnOfNumber
for i from 1 to numberOfRows
	if temp$ != ""
		for j from 1 to numberOfColumns - 1
			consonantLabel$ = Get column label... 1
			consonantName$ = Get value... i 'consonantLabel$'
			dotLabel$ = Get column label... j+1
			cZhi = Get value... i 'dotLabel$'
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
			Text... j Centre cZhi Half 'symbol$'
			if j = columnOfNumber - 1
				Black
				Text... 20.2 Left cZhi Half 'consonantName$'
			endif
			if j >= 2
				labelBeforeOneDot$ = Get column label... j
				cZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
				Black
				Draw line... j-1 cZhiBeforeOneDot j cZhi
			endif
		endfor
	elsif temp$ = ""
		for j from 2 to numberOfColumns - 1
			consonantLabel$ = Get column label... 1
			consonantName$ = Get value... i 'consonantLabel$'
			dotLabel$ = Get column label... j+1
			cZhi = Get value... i 'dotLabel$'
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
			Text... j Centre cZhi Half 'symbol$'
			if j = columnOfNumber - 1
				Black
				Text... 20.2 Left cZhi Half 'consonantName$'
			endif
			if j >= 3
				labelBeforeOneDot$ = Get column label... j
				cZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
				Black
				Draw line... j-1 cZhiBeforeOneDot j cZhi
			endif
		endfor
	endif
endfor
Font size... 13
Select outer viewport... 0.2 6 0 4
Text bottom... yes Frequency  Band
Text left... yes Energy (C value)
Font size... 10
Select outer viewport... 0 6.5 0 4
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
i=fileReadable("'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if integer_for_results = 1
Formula (column range)... dot1 dot20 fixed$ (self,0)
endif
Save as tab-separated file... 'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
plus Table newTable
Remove
printline 频带均值最大值为：'max:0'dB
printline 频带均值最小值为：'min:0'dB
Black
Line width... 1.0