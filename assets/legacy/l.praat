if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对基频赫兹数据进行归一化，得到T值，同时根据T值绘制声调T值图（绝对时长）。并将T值数据和T值图自动保存到软件所在文件夹下的data下。
#请读入基频赫兹数据表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.02.24

form set parameters
	boolean two_decimal_places_for_results 1
	boolean marks 1
	choice method 1
		button lgHertz
		button Hertz
	choice color 1
		button random
		button Red
		button Blue
		button Green
		button Black
	sentence name_of_file_to_be_saved T值表(绝对时长)
	sentence name_of_picture_to_be_saved T值图(绝对时长)
endform
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif
if index(name_of_file_to_be_saved$, "/") or index(name_of_file_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif
endeditor
pathFileName$ = chooseReadFile$: "请选择分析数据文件"
if pathFileName$ = ""
    exitScript: "已取消。"
endif
Modified read analysis table: pathFileName$, "tone dot1 dot2 dot3 dot4 dot5 dot6 dot7 dot8 dot9 duration file start end"
sourceTableID = selected("Table")
fileName$ = selected$("Table")
numberOfColumns = Get number of columns
while numberOfColumns > 11
    lastColumn = Get number of columns
    lastColumnLabel$ = Get column label: lastColumn
    Remove column: lastColumnLabel$
    numberOfColumns = Get number of columns
endwhile
numberOfRows = Get number of rows
numberOfColumns = Get number of columns
invalid = 0
for rows from 1 to numberOfRows
	for columns from 2 to numberOfColumns
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

numberOfColumns = 10
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
		numberOfColumns = 10
		numberOfDots = numberOfColumns
		for j from 2 to numberOfDots
			select Table 'fileName$'
			labelOfColumns$ = Get column label... j
			xMeanOfDot = Get group mean... 'labelOfColumns$' 'columnLabelFirst$' 'x$'
			columnLabelNew$ = Get column label... j
			select Table newTable
			Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
		endfor
	elsif i != 1
		if nameOfPhonemes$ != x$
			numberOfPhonemes = numberOfPhonemes + 1
			x$ = nameOfPhonemes$
			select Table newTable
			Append row
			Set string value... numberOfPhonemes 'columnLabelFirst$' 'x$'
			select Table 'fileName$'
			numberOfColumns = 10
			numberOfDots = numberOfColumns
			for j from 2 to numberOfDots
				select Table 'fileName$'
				labelOfColumns$ = Get column label... j
				xMeanOfDot = Get group mean... 'labelOfColumns$' 'columnLabelFirst$' 'x$'
				columnLabelNew$ = Get column label... j
				select Table newTable
				Set numeric value... numberOfPhonemes 'columnLabelNew$' 'xMeanOfDot'
			endfor
		endif
	endif
endfor
numberOfColumns = 10
for h from 1 to numberOfColumns
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
endfor
hertzMax = max
hertzMin = min
if method = 1
	min = log10(min)
	max = log10(max)
if max <= min
    exitScript: "基频范围为零，无法归一化。"
endif
	for legacyColumn from 2 to 10
    legacyColumnLabel$ = Get column label: legacyColumn
    Formula: legacyColumnLabel$, "log10(self)"
endfor
endif
clearinfo
numberOfColumns = 10
for h from 1 to numberOfColumns
	if h >= 2
		columnLabel$ = Get column label... h
		Formula... 'columnLabel$' (self-'min')/('max'-'min')*5
	endif
endfor
numberOfRowsNew = Get number of rows

select Table 'fileName$'
numberOfRows = Get number of rows
x = 1
max = 0
numberOfPhoneme = 0
y = 0
Create Table with column names... table numberOfRowsNew tone duration
select Table 'fileName$'
diaolei1$ = Get value... 1 tone
sum = Get value... 1 duration
for i from 2 to numberOfRows
	diaolei'i'$ = Get value... i tone
	j = i - 1
	if diaolei'i'$ = diaolei'j'$
		duration'i' = Get value... i duration
		sum = sum + duration'i'
		x = x + 1
		mean = sum / x
	elsif diaolei'i'$ != diaolei'j'$
		if x = 0
			mean = sum
		else
			mean = sum / x
		endif
		if max < mean
			max = mean
		endif
		diaoleix$ = diaolei'j'$
		y = y + 1
		select Table table
		Set string value... y tone 'diaoleix$'
		Set numeric value... y duration mean
		select Table 'fileName$'
		sum = 0
		x = 0
		duration'i' = Get value... i duration
		sum = sum + duration'i'
		x = x + 1
		mean = sum
	endif
endfor
x = i - 1
y = y + 1
j = j + 1
select Table table
diaoleix$ = diaolei'j'$
Set string value... y tone 'diaoleix$'
Set numeric value... y duration mean
durationMax = Get maximum... duration

Erase all
Font size... 14
Draw inner box
Axes... 0 durationMax 0 5
Marks bottom... 9 no yes no
if marks = 1
	Marks left... 6 no yes yes
endif
durationMax$ = fixed$(durationMax,3)
One mark bottom... 'durationMax$' no yes no 'durationMax$'
One mark bottom... 0 yes no no 0
Marks left every... 1 1 yes yes no
numberOfRows = Get number of rows
numberOfColumns = 10
for i from 1 to numberOfRows
	select Table table
	dration = Get value... i duration
	duationStep = dration / 8
	timeStart = 0
	for j from 1 to numberOfColumns - 1
		select Table newTable
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
		Text... timeStart Centre tZhi Half 'symbol$'
		if j = 10-1
			Black
			Text... durationMax+durationMax*0.03 Left tZhi Half 'toneName$'
		endif
		if j >= 2
			labelBeforeOneDot$ = Get column label... j
			tZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
			Black
			Draw line... timeStart-duationStep tZhiBeforeOneDot timeStart tZhi
		endif
		timeStart = timeStart + duationStep
	endfor
endfor
Font size... 13
Select outer viewport... 0.4 6 0 4
Text bottom... yes Time (s)
Text left... yes Pitch (T value)
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
select Table table
numberOfRows = Get number of rows
for inumberOfRows to numberOfRows
	select Table table
	tone$ = Get value: inumberOfRows, "tone"
	duration = Get value: inumberOfRows, "duration"
	select Table newTable
	if inumberOfRows = 1
		Append column: "duration"
	endif
	line = Search column: "tone", tone$
	Set numeric value: line, "duration", duration
endfor
if two_decimal_places_for_results = 1
	Formula (column range)... dot1 dot9 fixed$ (self,2)
endif
Save as tab-separated file... 'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
plus Table newTable
plus Table table
Remove
printline 基频均值最大值为：'hertzMax:0'Hz
printline 基频均值最小值为：'hertzMin:0'Hz