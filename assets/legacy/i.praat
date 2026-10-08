legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是统计声调时长。
#请读入基频赫兹数据表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.02.24

form set parameters
	boolean three_decimal_places_for_results 1
	sentence name_of_file_to_be_saved 声调时长表
	sentence name_of_picture_to_be_saved 声调时长图
endform

endeditor
pathFileName$ = chooseReadFile$: "请选择tone文件"
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
for i from 1 to 11
	column_label_temp$ = Get column label... i
	if i = 1
		Set string value... 1 'column_label_temp$' 'column_label_temp$'
	elsif i > 1
		Set numeric value... 1 'column_label_temp$' 'column_label_temp$'
	endif
	if i = 1
		Set column label (label)... 'column_label_temp$' tone
	elsif i > 1
		j = i - 1
		Set column label (label)... 'column_label_temp$' dot'j'
	endif
endfor
Sort rows... tone
numberOfRows = Get number of rows
x = 1
max = 0
numberOfPhoneme = 0
y = 0
Create Table with column names... table 'numberOfRows' tone duration
select Table 'fileName$'
diaolei1$ = Get value... 1 tone
sum = Get value... 1 dot10
for i from 2 to numberOfRows
	diaolei'i'$ = Get value... i tone
	j = i - 1
	if diaolei'i'$ = diaolei'j'$
		duration'i' = Get value... i dot10
		sum = sum + duration'i'
		x = x + 1
		mean = sum / x
	elsif diaolei'i'$ != diaolei'j'$
		if x = 0
			mean = sum
		else
			mean = sum / x
		endif
		diaoleix$ = diaolei'j'$
		y = y + 1
		select Table table
		diaoleix$ = diaolei'j'$
		Set string value... y tone 'diaoleix$'
		Set numeric value... y duration mean
		select Table 'fileName$'
		sum = 0
		x = 0
		duration'i' = Get value... i dot10
		sum = sum + duration'i'
		x = x + 1
		mean = sum
	endif
endfor
x = i - 1
y = y + 1
diaoleix$ = Get value... numberOfRows tone
10
select Table table
Set string value... y tone 'diaoleix$'
Set numeric value... y duration mean
s = 0
for i from 1 to 'numberOfRows'
	value$ = Get value... i-s tone
	if value$ = ""
		Remove row... i-s
		s = s + 1
	endif
endfor
max = Get maximum... duration
printline durationMax = 'max:3'
Append column... relativeDuration
numberOfRowsTemp = Get number of rows
for ii from 1 to numberOfRowsTemp
	valueTemp = Get value... ii duration
	valueTemp = valueTemp / max
	Set numeric value... ii relativeDuration 'valueTemp'
endfor

Select outer viewport... 0 6 4 6
Draw inner box
Axes... 0 y+1 0 max
Marks left... 4 yes yes no
for i from 1 to y
	tone$ = Get value... i tone
	duration = Get value... i duration
	Line width... 8.0
	Draw line... i 0 i duration
	Line width... 1.0
	One mark bottom... i no yes no 'tone$'
endfor
Text bottom... yes Tone
Text left... yes Duration (s)

Select outer viewport... 0 6 6 8
Draw inner box
Axes... 0 y+1 0 1
Marks left... 4 yes yes no
for i from 1 to y
	tone$ = Get value... i tone
	duration = Get value... i relativeDuration
	Line width... 8.0
	Draw line... i 0 i duration
	Line width... 1.0
	One mark bottom... i no yes no 'tone$'
endfor
Text bottom... yes Tone
Text left... yes Duration (normalized)
Select outer viewport... 0 6 4 8
Set column label (label)... duration duration(s)

createDirectory: legacyDataDirectory$
i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf")
if i = 1
	pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if three_decimal_places_for_results = 1
	Formula (column range)... duration(s) relativeDuration fixed$ (self,3)
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf
i=fileReadable("'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
Save as tab-separated file... 'legacyDataDirectory$'\'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
plus Table table
Remove
