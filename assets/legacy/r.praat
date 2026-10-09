if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对基频赫兹数据进行归一化，得到起伏度值，同时根据起伏度值绘制语调图图。并将起伏度值数据和起伏度值图自动保存到data目录下。
#请读入基频赫兹数据表后再运行本脚本。注意，运行本脚本将移去praat列表中的所有文件，如列表中有文件，请先行保存。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.05.09

endeditor
pathFileName$ = chooseReadFile$: "请选择分析数据文件"
if pathFileName$ = ""
    exitScript: "已取消。"
endif
Modified read analysis table: pathFileName$, "numberOfSentenceOrPhrase numberOfSyllable dot1 dot2 dot3 dot4 dot5 dot6 dot7 dot8 dot9 duration file start end"
sourceTableID = selected("Table")
fileName$ = selected$("Table")
numberOfColumns = Get number of columns
while numberOfColumns > 12
    lastColumn = Get number of columns
    lastColumnLabel$ = Get column label: lastColumn
    Remove column: lastColumnLabel$
    numberOfColumns = Get number of columns
endwhile
numberOfRows = Get number of rows
numberOfColumns = Get number of columns
number_of_columns = numberOfColumns
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
if max <= min or min <= 0
    exitScript: "基频范围无效，无法计算起伏度。"
endif
hertzMax = round(max)
hertzMin = round(min)
if reference_frequency = 1
	min = (12 * log2(min / 64))
	max = (12 * log2(max / 64))
elsif reference_frequency = 2
	min = (12 * log2(min / 50))
	max = (12 * log2(max / 50))
endif
if rectangle != 1
	clearinfo
endif
numberOfColumns = number_of_columns
for h from 1 to numberOfColumns
	if h >= 4
		columnLabel$ = Get column label... h
		if reference_frequency = 1
			Formula... 'columnLabel$' ((12 * log2(self / 64))-'min')/('max'-'min')*100
		elsif reference_frequency = 2
			Formula... 'columnLabel$' ((12 * log2(self / 50))-'min')/('max'-'min')*100
		endif
	endif
endfor

i=fileReadable("'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if integer_for_results = 1
	Formula (column range)... dot1 dot9 round (self)
endif
Save as tab-separated file... 'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls

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
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif
if index(name_of_file_to_be_saved$, "/") or index(name_of_file_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif
if phraseStart > phraseEnd
	exit phraseStart、phraseEnd填写有误。
endif
if rectangle = 1
    select Table newTable
    minimumRectangle = undefined
    maximumRectangle = undefined
    rowsRectangle = Get number of rows
    for rowRectangle from 1 to rowsRectangle
        syllableRectangle = Get value: rowRectangle, "numberOfSyllable"
        if syllableRectangle >= phraseStart and syllableRectangle <= phraseEnd
            for dotRectangle from 1 to 9
                valueRectangle = Get value: rowRectangle, "dot" + string$(dotRectangle)
                if minimumRectangle = undefined or valueRectangle < minimumRectangle
                    minimumRectangle = valueRectangle
                endif
                if maximumRectangle = undefined or valueRectangle > maximumRectangle
                    maximumRectangle = valueRectangle
                endif
            endfor
        endif
    endfor
    if minimumRectangle <> undefined and maximumRectangle <> undefined
        Blue
        xRectangle1 = (phraseStart-1)*10+1
        xRectangle2 = (phraseEnd-1)*10+9
        Draw line: xRectangle1, maximumRectangle, xRectangle2, maximumRectangle
        Draw line: xRectangle1, minimumRectangle, xRectangle2, minimumRectangle
        Draw line: xRectangle1, minimumRectangle, xRectangle1, maximumRectangle
        Draw line: xRectangle2, minimumRectangle, xRectangle2, maximumRectangle
    endif
endif
createDirectory: legacyDataDirectory$
i = fileReadable("'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'")
if i = 1
	pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if windows
    Save as 600-dpi PNG file... 'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'
else
    Save as PDF file... 'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'
endif
printline 句子基频均值最大值为：'hertzMax'Hz('max:1'St)
printline 句子基频均值最小值为：'hertzMin'Hz('min:1'St)
selectObject: sourceTableID
plus Table newTable
Remove

