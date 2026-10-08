legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是求多个Table文件起伏度值的平均值，并根据平均值画图，数据均保存到软件所在文件夹下的data下。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#请清空列表之后,读入所有待平均的起伏度值表,再运行脚本。
#2021.06.11

form set parameters
	comment 注意 主窗口只读入所有需平均的起伏度值表，不读入其他文件。
	boolean integer_for_results 1
	natural phraseStart 1
	natural phraseEnd 3
	choice color 1
		button random
		button Red
		button Blue
		button Green
		button Black
	boolean rectangle 1
	sentence name_of_file_to_be_saved 起伏度均值表(相对时长)
	sentence name_of_picture_to_be_saved 起伏度均值图(相对时长)
endform

if phraseStart > phraseEnd
	exit phraseStart、phraseEnd填写有误。
endif
endeditor
select all
Append
fileName$ = selected$("Table")
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	label$ = Get value... i numberOfSentenceOrPhrase
	if label$ = "numberOfSentenceOrPhrase"
		Remove row... i
		numberOfRows = numberOfRows -1
	endif
endfor
numberOfColumns = Get number of columns
invalid = 0
for rows from 1 to numberOfRows
	for columns from 4 to numberOfColumns
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
columnLabelFirst$ = Get column label... 3
Sort rows... 'columnLabelFirst$'
Create Table with column names... newTable 0 'columnLabelFirst$'
for h from 1 to numberOfColumns
		select Table 'fileName$'
		columnLabel$ = Get column label... h
		select Table newTable
		Append column... 'columnLabel$'
endfor
Remove column... 'columnLabelFirst$'
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
		numberOfDots = numberOfColumns
		for j from 1 to numberOfDots
			if j != 3
				select Table 'fileName$'
				labelOfColumns$ = Get column label... j
				xMeanOfDot = Get group mean... 'labelOfColumns$' 'columnLabelFirst$' 'x$'
				columnLabelNew$ = Get column label... j
				select Table newTable
				Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
			endif
		endfor
	elsif i != 1
		if nameOfPhonemes$ != x$
			numberOfPhonemes = numberOfPhonemes + 1
			x$ = nameOfPhonemes$
			select Table newTable
			Append row
			Set string value... numberOfPhonemes 'columnLabelFirst$' 'x$'
			select Table 'fileName$'
			numberOfDots = numberOfColumns
			for j from 1 to numberOfDots
				if j != 3
					select Table 'fileName$'
					labelOfColumns$ = Get column label... j
					xMeanOfDot = Get group mean... 'labelOfColumns$' 'columnLabelFirst$' 'x$'
					columnLabelNew$ = Get column label... j
					select Table newTable
					Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
				endif
			endfor
		endif
	endif
endfor
select Table newTable
Sort rows... numberOfSentenceOrPhrase numberOfSyllable
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

if rectangle != 1
	clearinfo
endif
i = fileReadable("'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls")
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
numberOfColumns = Get number of columns
for i from 1 to numberOfRows
	for j from 4 to numberOfColumns-1
		toneLabel$ = Get column label... 3
		toneName$ = Get value... i 'toneLabel$'
		dotLabel$ = Get column label... j
		numberOfSyllableTemp = Get value... i numberOfSyllable
		tZhi = Get value... i 'dotLabel$'
		zz = Get value... i numberOfSentenceOrPhrase
		if color = 1
			if zz mod 2 = 0 and zz mod 4 != 0
				Red
				symbol$ = "■"
			elsif zz mod 3 = 0
				Green
				symbol$ = "◆" 
			elsif zz mod 4 = 0
				Blue
				symbol$ = "●"
			elsif zz mod 5 = 0
				Cyan
				symbol$ = "▲" 
			else
				Black
				symbol$ = "▼" 
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

if rectangle = 1
	Blue
	Sort rows... numberOfSyllable numberOfSentenceOrPhrase
	for i from phraseStart to phraseEnd
		select Table newTable
		Extract rows where column (text)... numberOfSyllable "is equal to" 'i'
		Rename... 'i'
	endfor
	for xx from phraseStart to phraseEnd
		if xx = 1
			select Table 'xx'
		else
			plus Table 'xx'
		endif
	endfor
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
if rectangle != 1
	Font size... 10
endif
select all
Remove




