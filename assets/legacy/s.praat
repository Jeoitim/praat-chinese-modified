# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是求多个Table文件T值的平均值，并根据平均值画相对时长图，数据均保存到软件所在文件夹下的data下。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#请清空列表之后,读入所有待平均的T值表,再运行脚本。
#2019.05.09

form set parameters
	comment 注意 主窗口先读入所有需平均的声调T值表，不读入其他文件。
	boolean marks 1
	boolean two_decimal_places_for_results 1
	choice color 1
		button random
		button Red
		button Blue
		button Green
		button Black
	sentence name_of_file_to_be_saved T值均值表(相对时长)
	sentence name_of_picture_to_be_saved T值均值图(相对时长)
endform
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif
if index(name_of_file_to_be_saved$, "/") or index(name_of_file_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif

endeditor
select all
Append
fileName$ = selected$("Table")
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	label$ = Get value... i tone
	if label$ = "tone"
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

Erase all
Font size... 14
Draw inner box
Axes... 1 9 0 5
Marks bottom every... 1 1 yes yes no
if marks = 1
	Marks left... 6 yes yes yes
else
	Marks left... 6 yes yes no
endif
numberOfRows = Get number of rows
numberOfColumns = 10
for i from 1 to numberOfRows
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
			Text... 10.2 Left tZhi Half 'toneName$'
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
if two_decimal_places_for_results = 1
	Formula (column range)... dot1 dot9 fixed$ (self,2)
endif
Save as tab-separated file... 'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
Remove
select Table newTable
printline T值均值最大值为：'max:1'
printline T值均值最小值为：'min:1'
Black
Line width... 1.0


