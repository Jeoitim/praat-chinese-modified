legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量塞音的gap和VOT数据，并将数据自动保存到软件所在文件夹下的data\stop.txt中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.09.20

#repeat;如果一个文件要测量多次，例如语调，则开放。
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
fileReadable = fileReadable("'legacyDataDirectory$'/stopIPA.txt")
if fileReadable = 1
	endeditor
	Read from file: "'legacyDataDirectory$'/stopIPA.txt"
	row = Search column: "stop", fileName$
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
	sentence: "stop", ipa$
clicked = endPause: "继续", 1
stop$ = backslashTrigraphsToUnicode$(stop$)
editor Sound 'fileName$'
if stop$ = "stop" or stop$ = ""
	exit please set parameters correctly
endif
if print_title_of_data = 1
	appendInfoLine: "stop	gap	vot	file	gapStart	gapEnd	votStart	votEnd"
endif
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
timeStart0 = Get start of selection
timeEnd0 = Get end of selection
if timeEnd0 = timeStart0
	exit 您还没有选择gap区间。
endif
gap = timeEnd0 - timeStart0
pause 请选择VOT区间，然后点击Continue
timeStart = Get start of selection
timeEnd = Get end of selection
vot = timeEnd - timeStart
value$ = stop$ + tab$ + fixed$('gap',3) + tab$ + fixed$('vot',3)
createDirectory: legacyDataDirectory$
fileappend "'legacyDataDirectory$'/stop.txt" 'value$''tab$''fileName$''tab$''timeStart0:4''tab$''timeEnd0:4''tab$''timeStart:4''tab$''timeEnd:4''newline$'
printline 'value$''tab$''fileName$''tab$''timeStart0:4''tab$''timeEnd0:4''tab$''timeStart:4''tab$''timeEnd:4'