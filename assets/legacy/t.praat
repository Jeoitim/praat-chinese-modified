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
#本脚本的功能是求多个Table文件V值的平均值，并根据平均值画图，数据均保存到软件所在文件夹下的data下。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#请清空列表之后,读入所有待平均的V值表,再运行脚本。
#2019.05.09

form set parameters
	comment 注意 主窗口先读入所有需平均的元音V值表，不读入其他文件。
	boolean integer_for_results 1
	boolean marks 1
	choice picture_type 1
		button 两图垂直呈现
		button 两图水平呈现
	positive line 1.5
	sentence name_of_file_to_be_saved V值均值表
	sentence name_of_picture_to_be_saved V值均值图
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
fileName$ = selected$("Table")
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	label$ = Get value... i vowel
	if label$ = "vowel"
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
		min =min'h'
		max =max'h'
		zz = h - 1
		if zz != 3
			printline F'zz'V值均值最大值为：'max:0'
			printline F'zz'V值均值最小值为：'min:0'
		elsif zz = 3
			printline F3-F2V值均值最大值为：'max:0'
			printline F3-F2V值均值最小值为：'min:0'
		endif
	endif
endfor
Black
Select outer viewport... 0 6 0 4

#画F1~F2
Black
Set column label (label)... F1 F1(V value)
Set column label (label)... F2 F2(V value)
Scatter plot... "F2(V value)" 100 0 "F1(V value)" 100 0 vowel 18 yes
rows = Get number of rows
for j from 1 to rows
	valuef1 = Get value... j F1(V value)
	valuef2 = Get value... j F2(V value)
	valuevowel$ = Get value... j vowel
	if valuef1 >= 98 or valuef1 <= 2 or valuef2 >= 98 or valuef2 <= 2
		White
		Line width... 16
		Draw line... valuef2+line valuef1+line valuef2+line valuef1-line
		Draw line... valuef2+line valuef1+line valuef2-line valuef1+line
		Draw line... valuef2+line valuef1+line valuef2-line valuef1-line
		Draw line... valuef2+line valuef1-line valuef2-line valuef1+line
		Draw line... valuef2+line valuef1-line valuef2-line valuef1-line
		Draw line... valuef2-line valuef1+line valuef2-line valuef1-line
		Line width... 1
		Black
		Text special... valuef2 Centre valuef1 Half Times 16 0 'valuevowel$'
	endif
endfor
if marks = 1
	Red
	Draw line... 100 20 0 30
	Draw line... 100 80 0 70
	Draw line... 80 0 60 100
	Draw line... 20 0 40 100
endif

#画F1~F3-F2
Black
Set column label (label)... F3-F2 F3-F2(V value)
#Set column label (label)... F3 F3-F2
if picture_type = 1
	Select outer viewport... 0 6 4 8
elsif picture_type = 2
	Select outer viewport... 6 12 0 4
endif
Scatter plot... "F3-F2(V value)" 0 100 "F1(V value)" 100 0 vowel 18 yes
rows = Get number of rows
for j from 1 to rows
	valuef1 = Get value... j F1(V value)
	valuef32 = Get value... j F3-F2(V value)
	valuevowel$ = Get value... j vowel
	if valuef1 >= 98 or valuef1 <= 2 or valuef32 >= 98 or valuef32 <= 2
		White
		Line width... 16
		Draw line... valuef32+line valuef1+line valuef32+line valuef1-line
		Draw line... valuef32+line valuef1+line valuef32-line valuef1+line
		Draw line... valuef32+line valuef1+line valuef32-line valuef1-line
		Draw line... valuef32+line valuef1-line valuef32-line valuef1+line
		Draw line... valuef32+line valuef1-line valuef32-line valuef1-line
		Draw line... valuef32-line valuef1+line valuef32-line valuef1-line
		Line width... 1
		Black
		Text special... valuef32 Centre valuef1 Half Times 16 0 'valuevowel$'
	endif
endfor

Set column label (label)... "F1(V value)" F1
Set column label (label)... "F2(V value)" F2
Set column label (label)... "F3-F2(V value)" F3-F2
if marks = 1
	Red
	Draw line... 100 20 0 30
	Draw line... 100 80 0 70
	Draw line... 80 0 60 100
	Draw line... 20 0 40 100
	Black
endif
Select outer viewport... 0 6 0 4

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
i=fileReadable("'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if integer_for_results = 1
	Formula (column range)... F1 F3-F2 fixed$ (self,0)
endif
Save as tab-separated file... 'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
plus Table newTable
Remove
Line width... 1
Black
Line width... 1.0