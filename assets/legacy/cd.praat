if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对塞音时长数据进行归一化，绘制塞音格局图。并将数据和图自动保存到data目录下。
#请读入塞音时长数据表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.09.20

form set parameters
	comment 若清或浊塞音仅一个，请用绝对值画图，勿使用本菜单。
	boolean integer_for_results 1
	boolean there_are_voiced_stops 0
	positive line 1.5
	sentence name_of_file_to_be_saved 塞音时长表
	sentence name_of_picture_to_be_saved 塞音时长图
endform

endeditor
pathFileName$ = chooseReadFile$: "请选择stop文件"
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
columnLabel1$ = Get column label: 1
columnLabel2$ = Get column label: 3
columnLabel3$ = columnLabel2$ + columnLabel2$ 
if columnLabel1$ = columnLabel2$
	Set column label (index): 3, columnLabel3$
endif

x2 = Get number of columns
if x2 > 3
repeat
x2 = Get number of columns
x1$ = Get column label... x2
Remove column... 'x1$'
until x2 = 4
endif

Insert row... 1
for i from 1 to 3
	column_label_temp$ = Get column label... i
	if i = 1
		Set string value... 1 'column_label_temp$' 'column_label_temp$'
	elsif i > 1
		Set numeric value... 1 'column_label_temp$' 'column_label_temp$'
	endif
	if i = 1
		Set column label (label)... 'column_label_temp$' stop
	elsif i = 2
		Set column label (label)... 'column_label_temp$' GAP
	elsif i= 3
		Set column label (label)... 'column_label_temp$' VOT
	endif
endfor
fileName$ = selected$("Table")
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	label$ = Get value... i stop
	if label$ = "stop"
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
numberOfRows = Get number of rows
for h from 1 to numberOfColumns
	if h >= 2
		columnLabel$ = Get column label... h
		min =min'h'
		max =max'h'
		if h = 2
			printline GAP均值最大值为：'max:3's
			printline GAP均值最小值为：'min:3's
		elsif h = 3
			printline VOT均值最大值为：'max:3's
			printline VOT均值最小值为：'min:3's
		endif
		if there_are_voiced_stops = 0
			Formula... 'columnLabel$' (self-min)/(max-min)*100
		elsif there_are_voiced_stops = 1
			for bei from 1 to numberOfRows
				valueBei = Get value... 'bei' 'columnLabel$'
				if valueBei = 0
					Set string value... 'bei' 'columnLabel$' 0
				elsif valueBei > 0
					valueBei = (valueBei - 0) / (max - 0) * 100
					Set string value... 'bei' 'columnLabel$' 'valueBei'
				elsif valueBei < 0
					valueBei = (valueBei - min) / (0 - min) * 100
					Set string value... 'bei' 'columnLabel$' 'valueBei'
				endif
			endfor
		endif
	endif
endfor
Erase all
if there_are_voiced_stops = 0
	Select outer viewport... 0 6 0 4
elsif there_are_voiced_stops = 1
	Select outer viewport... 0 10 0 4
endif

#画塞音格局图
Black
if there_are_voiced_stops = 0
	Scatter plot... "VOT" 0 100 "GAP" 0 100 stop 18 no
elsif there_are_voiced_stops = 1
	Scatter plot... "VOT" -100 100 "GAP" 0 100 stop 18 no
endif
Draw inner box
Text bottom... yes VOT (normalized)
Text left... yes GAP (normalized)
Marks left every... 1 20 yes yes no
Marks bottom every... 1 20 yes yes no
One mark bottom: 0, "no", "yes", "yes", ""
rows = Get number of rows
for j from 1 to rows
	valueGAP = Get value... j GAP
	valueVOT = Get value... j VOT
	valuestop$ = Get value... j stop
	if valueGAP >= 98 or valueGAP >= 0 and valueGAP <= 2 or valueVOT >= 98 or valueVOT >= 0 and valueVOT <= 2 or valueGAP <= -98 or valueGAP <= 0 and valueGAP >= -2 or valueVOT <= -98 or valueVOT <= 0 and valueVOT >= -2
		White
		Line width... 16
		Draw line... valueVOT+line valueGAP+line valueVOT+line valueGAP-line
		Draw line... valueVOT+line valueGAP+line valueVOT-line valueGAP+line
		Draw line... valueVOT+line valueGAP+line valueVOT-line valueGAP-line
		Draw line... valueVOT+line valueGAP-line valueVOT-line valueGAP+line
		Draw line... valueVOT+line valueGAP-line valueVOT-line valueGAP-line
		Draw line... valueVOT-line valueGAP+line valueVOT-line valueGAP-line
		Line width... 1
		Black
		Text special... valueVOT Centre valueGAP Half Times 18 0 'valuestop$'
	endif
endfor
if there_are_voiced_stops = 0
	Select outer viewport... 0 6 0 4
elsif there_are_voiced_stops = 1
	Select outer viewport... 0 10 0 4
endif

#保存图表数据
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
i = fileReadable("'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls")
if i = 1
	pause 'name_of_file_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if integer_for_results = 1
	Formula (column range)... GAP VOT fixed$ (self,0)
endif
Save as tab-separated file... 'legacyDataDirectory$'/'name_of_file_to_be_saved$'.xls
select Table 'fileName$'
plus Table newTable
Remove
Black
Line width... 1
