legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是求多个Table文件能量分布模式的平均值，并根据平均值画图，数据均保存到软件所在文件夹下的data下。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#请清空列表之后,读入所有待平均的能量分布模式表,再运行脚本。
#2021.06.11

form set parameters
	comment 注意 主窗口先读入所有需平均的能量分布模式值表，不读入其他文件。
	boolean integer_for_results 1
	boolean marks 1
	boolean erase_all 1
	positive line 1.5
	sentence name_of_file_to_be_saved 能量分布模式均值表
	sentence name_of_picture_to_be_saved 能量分布模式均值图
endform

endeditor
select all
Append
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
numberOfColumns = Get number of columns
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

Black
Select outer viewport... 0 6 0 4

#画
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
i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf")
if i = 1
	pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf
i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if integer_for_results = 1
	Formula (column range)... Gravity centreOfGravity fixed$ (self,0)
endif
Save as tab-separated file... 'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
plus Table newTable
Remove
Line width... 1
10
