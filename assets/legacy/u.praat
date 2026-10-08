legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据首列排序统计指定列数据（求平均值并根据平均值或最大值求相对化值）。并将数据自动保存到软件所在文件夹下的data\平均值.xls中。
#请读入有关数据表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.05.16

form set parameters
	comment 注意 请输入待计算的列的位次，且该列不含有非数值内容。
	natural column 2
	sentence name_of_vertical_axis Average amplitude
	sentence name_of_file_to_be_saved 阴平加轻声平均幅度表
	sentence name_of_picture_to_be_saved 阴平加轻声平均幅度图
	choice result_type_for_mean 1
		button three_decimal_places
		button integer
	boolean two_decimal_places_for_normalized_results 1
	boolean delete_first_two_character 0
endform

if name_of_vertical_axis$ = ""
	exit 'name_of_vertical_axis$'的内容不能为空
endif
endeditor
pathFileName$ = chooseReadFile$: "请选择Table文件"
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
Insert row... 1
numberOfColumns = Get number of columns
for i from 1 to numberOfColumns
	column_label_temp$ = Get column label... i
	if i = 1
		Set string value... 1 'column_label_temp$' 'column_label_temp$'
	elsif i > 1
		Set string value... 1 'column_label_temp$' 'column_label_temp$'
	endif
	Set column label (label)... 'column_label_temp$' dot'i'
endfor

numberOfRows = Get number of rows
numberOfColumns = Get number of columns
invalid = 0
for rows from 1 to numberOfRows
	columnLabel$ = Get column label... 'column'
	value = Get value... 'rows' 'columnLabel$'
	y = value * 0
	y$ = "'y'"
	if y$ = "--undefined--"
		invalid = invalid + 1
	endif
endfor
if invalid != 0
	exit 指定列中应该为数值数据的地方有'invalid'个非数值数据，文件疑被人为修改过或非本软件生成！请先处理。
endif

Sort rows... dot1
numberOfRows = Get number of rows
x = 1
max = 0
numberOfPhoneme = 0
y = 0
Create Table with column names... table 'numberOfRows' name mean value(self/mean) value(self/max)
select Table 'fileName$'
name1$ = Get value... 1 dot1
columnLabel$ = Get column label... 'column'
sum = Get value... 1 'columnLabel$'
max = Get value... 1 'columnLabel$'
for i from 2 to numberOfRows
	name'i'$ = Get value... i dot1
	j = i - 1
	if name'i'$ = name'j'$
		data'i' = Get value... i 'columnLabel$'
		sum = sum + data'i'
		x = x + 1
		mean = sum / x
	elsif name'i'$ != name'j'$
		if x = 0
			mean = sum
		else
			mean = sum / x
		endif
		namex$ = name'j'$
		y = y + 1
		select Table table
		Set string value... y name 'namex$'
		Set string value... y mean 'mean'
		select Table 'fileName$'
		sum = 0
		x = 0
		data'i' = Get value... i 'columnLabel$'
		sum = sum + data'i'
		x = x + 1
		mean = sum / x
	endif
endfor

x = i - 1
y = y + 1
namex$ = Get value... numberOfRows dot1
select Table table
Set string value... y name 'namex$'
Set string value... y mean 'mean'
s = 0
for i from 1 to 'numberOfRows'
	value$ = Get value... i-s name
	if value$ = ""
		Remove row... i-s
		s = s + 1
	endif
endfor
max = Get maximum... mean
if result_type_for_mean = 1
	Formula (column range)... mean mean fixed$ (self,3)
elsif result_type_for_mean = 2
	Formula (column range)... mean mean fixed$ (self,0)
endif
line_width = 8.0
Erase all
Select outer viewport... 0 6 0 4
Draw inner box
Axes... 0 y+1 0 max
Marks left... 6 yes yes no
for i from 1 to y
	dot$ = Get value... i name
	if delete_first_two_character = 1
		length = length(dot$)
		if length < 3
			exit 首列内容的长度有的小于3个字符，不能截取。
		else
			dot$ = right$ (dot$, length-2)
		endif
		
	endif
	data = Get value... i mean
	Line width... line_width
	Draw line... i 0 i data
	Line width... 1.0
	One mark bottom... i no yes no 'dot$'
endfor
Font size... 12
Select outer viewport... 0 6 0 4
if name_of_vertical_axis$ = "Duration" or name_of_vertical_axis$ = "duration"
Text left... yes 'name_of_vertical_axis$'(s)
else
Text left... yes 'name_of_vertical_axis$'
endif
Font size... 10

createDirectory: legacyDataDirectory$
i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'1.emf")
if i = 1
pause 'name_of_picture_to_be_saved$'1已经存在，请将其先移走，否则会被覆盖！
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'1.emf

numberOfRows = Get number of rows
for i from 1 to numberOfRows
	value = Get value... i mean
	Set string value... i value(self/mean) 'value'
	Set string value... i value(self/max) 'value'
endfor

meanAll = Get mean... value(self/mean)
maxAll = Get maximum... value(self/mean)
Formula... value(self/mean) self/meanAll
if two_decimal_places_for_normalized_results = 1
	Formula (column range)... value(self/mean) value(self/mean) fixed$ (self,2)
endif
maxAllNew = Get maximum... value(self/mean)
Select outer viewport... 0 6 4 8
Draw inner box
Axes... 0 y+1 0 maxAllNew
Marks left... 6 yes yes no
for i from 1 to y
dot$ = Get value... i name
	if delete_first_two_character = 1
		length = length(dot$)
		if length < 3
			exit 首列内容的长度有的小于3个字符，不能截取。
		else
			dot$ = right$ (dot$, length-2)
		endif
		
	endif
data = Get value... i value(self/mean)
Line width... line_width
Draw line... i 0 i data
Line width... 1.0
One mark bottom... i no yes no 'dot$'
One mark left... 1 yes yes yes 1
endfor
Font size... 12
Select outer viewport... 0 6 4 8
Text left... yes 'name_of_vertical_axis$' (normalized)
Font size... 10
clearinfo
printline 平均值 = 'meanAll'

i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'2.emf")
if i = 1
pause 'name_of_picture_to_be_saved$$'2已经存在，请将其先移走，否则会被覆盖！
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'2.emf

meanAll = Get mean... value(self/max)
maxAll = Get maximum... value(self/max)
Formula... value(self/max) self/maxAll
if two_decimal_places_for_normalized_results = 1
	Formula (column range)... value(self/max) value(self/max) fixed$ (self,2)
endif
maxAllNew = Get maximum... value(self/max)
Select outer viewport... 0 6 8 12
Draw inner box
Axes... 0 y+1 0 maxAllNew
Marks left... 6 yes yes no
for i from 1 to y
dot$ = Get value... i name
	if delete_first_two_character = 1
		length = length(dot$)
		if length < 3
			exit 首列内容的长度有的小于3个字符，不能截取。
		else
			dot$ = right$ (dot$, length-2)
		endif
		
	endif
data = Get value... i value(self/max)
Line width... line_width
Draw line... i 0 i data
Line width... 1.0
One mark bottom... i no yes no 'dot$'
One mark left... 1 yes yes yes 1
endfor
Font size... 12
Select outer viewport... 0 6 8 12
Text left... yes 'name_of_vertical_axis$' (normalized)
Font size... 10
printline 最大值 = 'maxAll'

i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'3.emf")
if i = 1
pause 'name_of_picture_to_be_saved$'3已经存在，请将其先移走，否则会被覆盖！
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'3.emf
i=fileReadable("'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls")
if i = 1
pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
Save as tab-separated file... 'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls

select Table 'fileName$'
plus Table table
Remove




