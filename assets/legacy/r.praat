legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对基频赫兹数据进行归一化，得到起伏度值，同时根据起伏度值绘制语调图图。并将起伏度值数据和起伏度值图自动保存到data目录下。
#请读入基频赫兹数据表后再运行本脚本。注意，运行本脚本将移去praat列表中的所有文件，如列表中有文件，请先行保存。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.05.09

endeditor
pathFileName$ = chooseReadFile$: "请选择语调的基频数据文件"
if pathFileName$ != ""
	Read Strings from raw text file: pathFileName$
	stringsFileName$ = selected$("Strings")
	numberOfStrings = Get number of strings
	spacespace$ = " " + " "
	tabtab$ = tab$ + tab$
	for i from 1 to numberOfStrings
		string$ = Get string: i
		string$ = replace$(string$, spacespace$, " ", 0)
		string$ = replace$(string$, " ", tab$, 0)
		repeat
			string$ = replace$(string$, tabtab$, tab$, 0)
		until index(string$, tabtab$) = 0
		Set string: i, string$
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
columnLabel2$ = Get column label: 13
columnLabel3$ = columnLabel2$ + columnLabel2$ 
if columnLabel1$ = columnLabel2$
	Set column label (index): 13, columnLabel3$
endif

x2 = Get number of columns
if x2 > 12
repeat
x2 = Get number of columns
x1$ = Get column label... x2
Remove column... 'x1$'
until x2 = 13
endif
select all
minus Table 'fileName$'
nocheck Remove
select Table 'fileName$'
Insert row... 1
number_of_columns = Get number of columns
for i from 1 to number_of_columns
	column_label_temp$ = Get column label... i
	if i = 1
		Set string value... 1 'column_label_temp$' 'column_label_temp$'
	elsif i > 1
		Set numeric value... 1 'column_label_temp$' 'column_label_temp$'
	endif
	if i = 1
		Set column label (label)... 'column_label_temp$' numberOfSentenceOrPhrase
	elsif i = 2
		Set column label (label)... 'column_label_temp$' numberOfSyllable
	elsif i > 1
		j = i - 2
		Set column label (label)... 'column_label_temp$' dot'j'
	endif
endfor

fileName$ = selected$("Table")
numberOfRows = Get number of rows
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
Insert column... 3 bianMa
for i from 1 to numberOfRows
	a$ = Get value... i numberOfSentenceOrPhrase
	b$ = Get value... i numberOfSyllable
	c$ = a$ + "~" + b$
	Set string value... i bianMa 'c$'
endfor

numberOfColumns = number_of_columns + 1
columnLabelFirst$ = Get column label... 1
columnLabelSecond$ = Get column label... 2
Sort rows... 'columnLabelFirst$' 'columnLabelSecond$'
Create Table with column names... newTable 0 'columnLabelFirst$' 'columnLabelSecond$'
for h from 1 to numberOfColumns
	if h >= 3
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
	nameOfPhonemes1$ = Get value... i 'columnLabelFirst$'
	nameOfPhonemes2$ = Get value... i 'columnLabelSecond$'
	nameOfPhonemes3$ = Get value... i bianMa
	if i = 1
		numberOfPhonemes = numberOfPhonemes + 1
		x1$ = nameOfPhonemes1$
		x2$ = nameOfPhonemes2$
		x3$ = nameOfPhonemes3$
		select Table newTable
		Append row
		Set string value... numberOfPhonemes 'columnLabelFirst$' 'x1$'
		Set string value... numberOfPhonemes 'columnLabelSecond$' 'x2$'
		Set string value... numberOfPhonemes bianMa 'x3$'
		select Table 'fileName$'
		numberOfColumns = number_of_columns + 1
		numberOfDots = numberOfColumns
		for j from 4 to numberOfDots
			select Table 'fileName$'
			labelOfColumns$ = Get column label... j
			xMeanOfDot = Get group mean... 'labelOfColumns$' bianMa 'x3$'
			columnLabelNew$ = Get column label... j
			select Table newTable
			if j = numberOfDots
				Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot:3'
			else
				Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
			endif
		endfor	
	elsif i != 1
		if nameOfPhonemes1$ != x1$ or nameOfPhonemes2$ != x2$
			numberOfPhonemes = numberOfPhonemes + 1
			x1$ = nameOfPhonemes1$
			x2$ = nameOfPhonemes2$
			x3$ = nameOfPhonemes3$
			select Table newTable
			Append row
			Set string value... numberOfPhonemes 'columnLabelFirst$' 'x1$'
			Set string value... numberOfPhonemes 'columnLabelSecond$' 'x2$'
			Set string value... numberOfPhonemes bianMa 'x3$'
			select Table 'fileName$'
			numberOfColumns = number_of_columns + 1
			numberOfDots = numberOfColumns
			for j from 4 to numberOfDots
				select Table 'fileName$'
				labelOfColumns$ = Get column label... j
				xMeanOfDot = Get group mean... 'labelOfColumns$' bianMa 'x3$'
				columnLabelNew$ = Get column label... j
				select Table newTable
				if j = numberOfDots
					Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot:3'
				else
					Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
				endif
			endfor
		endif
	endif
endfor

numberOfColumns = number_of_columns
for h from 1 to numberOfColumns
	if h >= 4
		select Table newTable
		columnLabel$ = Get column label... h
		minNew = Get minimum... 'columnLabel$'
		if h = 4
			min = minNew
		endif
		if min > minNew
			min = minNew
		endif
		maxNew = Get maximum... 'columnLabel$'
		if h = 4
			max = maxNew
		endif
		if max < maxNew
			max = maxNew
		endif
	endif
endfor
hertzMax = round(max)
hertzMin = round(min)
if reference_frequency = 1
	min = hertzToSemitonesRe64(min)
	max = hertzToSemitonesRe64(max)
elsif reference_frequency = 2
	min = hertzToSemitonesRe50(min)
	max = hertzToSemitonesRe50(max)
endif
if rectangle != 1
	clearinfo
endif
numberOfColumns = number_of_columns
for h from 1 to numberOfColumns
	if h >= 4
		columnLabel$ = Get column label... h
		if reference_frequency = 1
			Formula... 'columnLabel$' (hertzToSemitonesRe64(self)-'min')/('max'-'min')*100
		elsif reference_frequency = 2
			Formula... 'columnLabel$' (hertzToSemitonesRe50(self)-'min')/('max'-'min')*100
		endif
	endif
endfor

i=fileReadable("'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if integer_for_results = 1
	Formula (column range)... dot1 dot9 round (self)
endif
Save as tab-separated file... 'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls

numberOfSyllable = Get maximum... numberOfSyllable
if rectangle != 1
	Erase all
endif
Font size... 10
Draw inner box
Axes... 1 9*numberOfSyllable+numberOfSyllable-1 0 100
Marks bottom every... 1 1 no yes no
Marks bottom every... 1 10 yes yes no
Marks left every... 1 10 yes yes no
Text bottom... yes Time (normalized)
Text left... yes Pitch (Q value)
numberOfRows = Get number of rows
numberOfColumns = number_of_columns + 1
for i from 1 to numberOfRows
	for j from 4 to numberOfColumns-1
		toneLabel$ = Get column label... 3
		toneName$ = Get value... i 'toneLabel$'
		dotLabel$ = Get column label... j
		numberOfSyllableTemp = Get value... i numberOfSyllable
		tZhi = Get value... i 'dotLabel$'
		zz = Get value... i numberOfSentenceOrPhrase
		if color = 1
			if zz = 1 or zz = 9
				Red
				symbol$ = "■"
			elsif zz = 2 or zz = 10
				Green
				symbol$ = "◆"
			elsif zz = 3 or zz = 11
				Blue
				symbol$ = "▲"
			elsif zz = 4 or zz = 12
				Black
				symbol$ = "▼"
			elsif zz = 5 or zz = 13
				Red
				symbol$ = "□"
			elsif zz = 6 or zz = 14
				Green
				symbol$ = "◇"
			elsif zz = 7 or zz = 15
				Blue
				symbol$ = "△"
			elsif zz = 8 or zz = 16
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
		
		Text... j-3+9*(numberOfSyllableTemp-1)+(numberOfSyllableTemp-1) Centre tZhi Half 'symbol$'

		if j-3+9*(numberOfSyllableTemp-1)+(numberOfSyllableTemp-1) != 1+(9+1)*(numberOfSyllableTemp-1)
			labelBeforeOneDot$ = Get column label... j-1
			tZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
			Black
			Draw line... (j-3)+9*(numberOfSyllableTemp-1)+(numberOfSyllableTemp-1)-1 tZhiBeforeOneDot (j-3)+9*(numberOfSyllableTemp-1)+(numberOfSyllableTemp-1) tZhi
		endif
	endfor
endfor

form set parameters
	comment 起伏度计算中半音参考频率设为64Hz（多数人基频高于此）
	comment 同一份数据半音参考设为任何值，计算中抵消，起伏度相同
	boolean integer_for_results 1
	#natural number_of_columns 12
	natural phraseStart 1
	natural phraseEnd 3
	choice reference_frequency 1
		button 64
		button 50
	choice color 1
		button random
		button Red
		button Blue
		button Green
		button Black
	boolean rectangle 1
	sentence name_of_file_to_be_saved 起伏度值表(相对时长)
	sentence name_of_picture_to_be_saved 起伏度值图(相对时长)
endform
if phraseStart > phraseEnd
	exit phraseStart、phraseEnd填写有误。
endif
if rectangle = 1
	Blue
	Sort rows... numberOfSyllable numberOfSentenceOrPhrase
	for i from phraseStart to phraseEnd
		select Table newTable
		Extract rows where column (text)... numberOfSyllable "is equal to" 'i'
		if "'i'" = fileName$
			Rename... 'i'_'i'
		else
			Rename... 'i'
		endif
	endfor
	select all
	minus Table newTable
	minus Table 'fileName$'
	Append
	for j from 1 to 9
		maxNew = Get maximum... dot'j'
		if j = 1
			max0 = maxNew
		endif
		if max0 < maxNew
			max0 = maxNew
		endif
		minNew = Get minimum... dot'j'
		if j = 1
			min0 = minNew
		endif
		if min0 > minNew
			min0 = minNew
		endif
	endfor
	printline 'phraseStart'~'phraseEnd'方框起伏度最大值为：'max0:0'
	printline 'phraseStart'~'phraseEnd'方框起伏度最小值为：'min0:0'
	Draw line... (phraseStart-1)*10+1 max0 (phraseEnd-1)*10+9 max0
	Draw line... (phraseStart-1)*10+1 min0 (phraseEnd-1)*10+9 min0
	Draw line... (phraseStart-1)*10+1 min0 (phraseStart-1)*10+1 max0
	Draw line... (phraseEnd-1)*10+9 min0 (phraseEnd-1)*10+9 max0

	valueDot = (phraseStart + (phraseEnd - phraseStart + 1)/2 - 1) * 10
	Text... valueDot Centre max0+5 Half 'max0:0'
	Text... valueDot Centre min0-5 Half 'min0:0'
endif
createDirectory: legacyDataDirectory$
i = fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf")
if i = 1
	pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf
printline 句子基频均值最大值为：'hertzMax'Hz('max:1'St)
printline 句子基频均值最小值为：'hertzMin'Hz('min:1'St)
select all
if rectangle != 1
	Font size... 10
endif
Remove

