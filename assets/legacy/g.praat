legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量时长数据，并将数据自动保存到软件所在文件夹下的data下。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.02.24

#repeat;如果一个文件要测量多次，例如语调，则开放。
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
fileReadable = fileReadable("'legacyDataDirectory$'\segmentIPA.txt")
if fileReadable = 1
	endeditor
	Read from file: "'legacyDataDirectory$'\segmentIPA.txt"
	row = Search column: "segment", fileName$
	if row != 0
		ipa$ = Get value: row, "IPA"
	else
		ipa$ = ""
	endif
	Remove
	select Sound 'fileName$'
else
	ipa$ = ""
endif

beginPause: "Set parameters"
	boolean: "print_title_of_data", 0
	sentence: "segment", ipa$
clicked = endPause: "继续", 1
editor Sound 'fileName$'
if segment$ = "segment" or segment$ = ""
exit please set parameters correctly
endif
timeStart = Get start of selection
timeEnd = Get end of selection
value = timeEnd - timeStart
if value = 0
exit 您还没有选择待测语音部分
elsif value != 0
printline 'segment$''tab$''value:3''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
createDirectory: legacyDataDirectory$
fileappend "'legacyDataDirectory$'\duration.txt" 'segment$''tab$''value:3''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4''newline$'
endif
