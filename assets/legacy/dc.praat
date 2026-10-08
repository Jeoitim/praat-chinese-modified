legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据tone.txt文件自动标注声音文件的声调信息。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2022.10.28

form set parameters
	sentence sound_type wav
endform

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
		repeat;只能用repeat？不能用replace，tab$这么牛？！
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
numberOfColumns = Get number of columns
Insert row... 1
for i from 1 to numberOfColumns
	column_label_temp$ = Get column label... i
	Set string value... 1 'column_label_temp$' 'column_label_temp$'
	if i = 1
		Set column label (label)... 'column_label_temp$' tone
	elsif i > 1
		j = i - 1
		Set column label (label)... 'column_label_temp$' dot'j'
	endif
endfor
fileName$ = selected$("Table")
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	label$ = Get value... i tone
	if label$ = "tone"
		Remove row... i
		numberOfRows = numberOfRows -1
	endif
endfor

numberOfRows = Get number of rows
for i from 1 to numberOfRows
	select Table 'stringsFileName$'
	tone$ = Get value... i tone
	soundFile$ = Get value... i dot11
	time1 = Get value... i dot12
	time2 = Get value... i dot13
	stringsFileNameAll$ = stringsFileName$ + ".txt"
	soundPathFileName$ = pathFileName$ - stringsFileNameAll$ + soundFile$ + "." + sound_type$
	soundFileReadable = fileReadable(soundPathFileName$)
	if soundFileReadable != 1
		appendInfoLine: "'soundFile$'不存在"
	elsif soundFileReadable = 1
		Read from file: soundPathFileName$
		textGridPathFileName$ = pathFileName$ - stringsFileNameAll$ + soundFile$ + ".TextGrid"
		textGridFileReadable = fileReadable(textGridPathFileName$)
		if textGridFileReadable != 1
			To TextGrid: "tone", ""
		elsif textGridFileReadable = 1
			Read from file: textGridPathFileName$
		endif
			nocheck Insert boundary: 1, time1
			index = Get interval at time: 1, time1
			Set interval text: 1, index, "'tone$'"
			nocheck Insert boundary: 1, time2
			Save as text file: textGridPathFileName$
			select TextGrid 'soundFile$'
			Remove
		select Sound 'soundFile$'
		Remove
	endif
endfor
exit 标注完成！