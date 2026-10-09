legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量幅度积数据，并将数据自动保存到软件所在文件夹下的data\amplitude.txt中。
#声音文件的采样精度必须为16位。
#请在声音编辑器中运行本脚本.
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.04.22

#repeat;如果一个文件要测量多次，例如语调，则开放。
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
fileReadable = fileReadable("'legacyDataDirectory$'/unitIPA.txt")
if fileReadable = 1
	endeditor
	Read from file: "'legacyDataDirectory$'/unitIPA.txt"
	row = Search column: "unit", fileName$
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
	comment: "注意 软件分别测量所选段平均幅度、时长、幅度积"
	boolean: "print_title_of_data", 0
	sentence: "unit", ipa$
clicked = endPause: "继续", 1
unit$ = backslashTrigraphsToUnicode$(unit$)
editor Sound 'fileName$'

timeStart = Get start of selection
timeEnd = Get end of selection
duration = timeEnd - timeStart
if duration = 0
	exit 您还没有选择声音片段，请选择后再运行菜单。
endif
if print_title_of_data = 1
	appendInfoLine: "unit	amplitudeMean	duration	amplitudeIntegral	file	start	end"
endif
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
Extract selected sound (preserve times)
endeditor
s = 0
number = Bei 幅度积1
for i from 1 to number
value = Bei 幅度积2... 0 'i'
value = abs(value)
s = s + value
endfor
amplitude = s / number
amplitudeMean = Bei 幅度积3... amplitude
fuduji = amplitudeMean * duration
createDirectory: legacyDataDirectory$
fileappend "'legacyDataDirectory$'/amplitude.txt" 'unit$''tab$''amplitudeMean:0''tab$''duration:3''tab$''fuduji:1''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4''newline$'
printline 'unit$''tab$''amplitudeMean:0''tab$''duration:3''tab$''fuduji:1''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
Remove
select Sound 'fileName$'
editor Sound 'fileName$'
Select... timeStart timeEnd
#until 0 > 1



