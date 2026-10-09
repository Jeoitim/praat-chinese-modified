if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对辅音谱重心和分散程度数据进行归一化，同时绘制辅音图。并将数据和辅音图图自动保存到data目录下。
#请读入energyDistribution.txt后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.12.11

form set parameters
	boolean integer_for_results 1
	boolean marks 1
	boolean erase_all 1
	positive line 1.5
	sentence name_of_file_to_be_saved 能量分布模式表
	sentence name_of_picture_to_be_saved 能量分布模式图
endform
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif
if index(name_of_file_to_be_saved$, "/") or index(name_of_file_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif

endeditor
pathFileName$ = chooseReadFile$: "请选择energyDistribution文件"
if pathFileName$ = ""
    exitScript: "已取消。"
endif
Modified read analysis table: pathFileName$, ""

fileName$ = selected$("Table")
columnLabel1$ = Get column label: 1
columnLabel2$ = Get column label: 5
columnLabel3$ = columnLabel2$ + columnLabel2$ 
if columnLabel1$ = columnLabel2$
	Set column label (index): 5, columnLabel3$
endif

x2 = Get number of columns
if x2 > 4
repeat
x2 = Get number of columns
x1$ = Get column label... x2
Remove column... 'x1$'
until x2 = 5
endif

numberOfColumns = Get number of columns
for i from 1 to numberOfColumns
	column_label_temp$ = Get column label... i
	if i = 1
		Set column label (label)... 'column_label_temp$' consonant
	elsif i = 2
		Set column label (label)... 'column_label_temp$' Gravity
	elsif i = 3
		Set column label (label)... 'column_label_temp$' Dispersion
	elsif i = 4
		Set column label (label)... 'column_label_temp$' centreOfGravity
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
		numberOfColumns = Get number of columns
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
			numberOfColumns = Get number of columns
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
select Table newTable
numberOfColumns = Get number of columns
for h from 1 to numberOfColumns
	if h >= 2
		select Table newTable
		columnLabel$ = Get column label... h
		minNew = Get minimum... 'columnLabel$'
		min'h' = minNew
		maxNew = Get maximum... 'columnLabel$'
		max'h' = maxNew
	endif
endfor
clearinfo
numberOfColumns = Get number of columns
for h from 1 to numberOfColumns
	if h >= 2
		columnLabel$ = Get column label... h
		min = min'h'
		max = max'h'
		zz = h - 1
		if zz = 1
			printline Gravity均值最大值为：'max:1'
			printline Gravity均值最小值为：'min:1'
		elsif zz = 2
			printline Dispersion均值最大值为：'max:1'
			printline Dispersion均值最小值为：'min:1'
		elsif zz = 3
			printline centreOfGravity均值最大值为：'max:0'Hz
			printline centreOfGravity均值最小值为：'min:0'Hz
		endif
		if h >= 2 and h < numberOfColumns
			Formula... 'columnLabel$' (self-min)/(max-min)*100
		endif
	endif
endfor

#画
Black
Select outer viewport: 0, 6, 0, 4
if erase_all = 1
	Erase all
endif
Black
Scatter plot... Dispersion 0 100 Gravity 0 100 consonant 18 yes
Marks left every... 1 20 yes yes no
Marks bottom every... 1 20 yes yes no
if marks = 1
	Marks left... 6 no yes yes
endif
rows = Get number of rows
for j from 1 to rows
	valueM = Get value... j Gravity
	valueS = Get value... j Dispersion
valueconsonant$ = Get value... j consonant
if valueM >= 98 or valueM <= 2 or valueS >= 98 or valueS <= 2
White
Line width... 26
Draw line... valueS+line valueM+line valueS+line valueM-line
Draw line... valueS+line valueM+line valueS-line valueM+line
Draw line... valueS+line valueM+line valueS-line valueM-line
Draw line... valueS+line valueM-line valueS-line valueM+line
Draw line... valueS+line valueM-line valueS-line valueM-line
Draw line... valueS-line valueM+line valueS-line valueM-line
Line width... 1
Black
Text special... valueS Centre valueM Half Times 18 0 'valueconsonant$'
endif
endfor
Red

#保存图表数据
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
i=fileReadable("'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if integer_for_results = 1
	Formula (column range)... Gravity centreOfGravity fixed$ (self,0)
endif
Save as tab-separated file... 'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
plus Table newTable
Remove
Line width... 1
10
