legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是求多个Table文件频带能量值的平均值，并根据平均值画图，数据均保存到软件所在文件夹下的data下。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#请清空列表之后,读入所有待平均的频带能量值表,再运行脚本。
#2021.06.11

form set parameters
	comment 注意 主窗口先读入所有需平均的频带能量值表，不读入其他文件。
	boolean integer_for_results 1
	choice color 1
		button random
		button Red
		button Blue
		button Green
		button Black
	boolean marks 1
	sentence name_of_file_to_be_saved 频带能量均值表(相对时长)
	sentence name_of_picture_to_be_saved 频带能量均值图(相对时长)
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
whatIsDot1$ = Get value... 1 dot1
if whatIsDot1$ = "--undefined--"
	columnStart = 3
elsif whatIsDot1$ != "--undefined--"
	columnStart = 2
endif
for rows from 1 to numberOfRows
	for columns from columnStart to numberOfColumns
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
for h from 2 to numberOfColumns
		select Table 'fileName$'
		columnLabel$ = Get column label... h
		select Table newTable
		Append column... 'columnLabel$'
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
		for j from columnStart to numberOfDots
			if j != 1
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
			for j from columnStart to numberOfDots
				if j != 1
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
Erase all
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
numberOfColumns = Get number of columns
for i from 1 to numberOfRows
	if whatIsDot1$ != "--undefined--"
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
			if j = numberOfColumns - 1
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
	elsif whatIsDot1$ = "--undefined--"
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
			if j = numberOfColumns - 1
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
Text bottom... yes Hertz Band
Text left... yes Energy (C value)
Font size... 10
Select outer viewport... 0 6.5 0 4
createDirectory: legacyDataDirectory$
i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf")
if i = 1
	pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf
i=fileReadable("'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if integer_for_results = 1
Formula (column range)... dot1 dot20 fixed$ (self,0)
endif
Save as tab-separated file... 'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
plus Table newTable
Remove
Black
Line width... 1.0
