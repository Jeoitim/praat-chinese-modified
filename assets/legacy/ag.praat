legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量频带能量（19或20个测量点）。
#请在主编辑器中选定声音文件后运行。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.10.18

#repeat;如果一个文件要测量多次，例如语调，则开放。
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
fileReadable = fileReadable("'legacyDataDirectory$'/consonantIPA.txt")
if fileReadable = 1
	endeditor
	Read from file: "'legacyDataDirectory$'/consonantIPA.txt"
	row = Search column: "consonant", fileName$
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
	boolean: "include_first_band", 0
	sentence: "consonant", ipa$
	real: "hertz_start", 0
clicked = endPause: "继续", 1
editor Sound 'fileName$'
if consonant$ = "consonant" or consonant$ = ""
	exit please set parameters correctly
endif
consonant$ = backslashTrigraphsToUnicode$(consonant$)
if hertz_start < 0
	exit hertz start必须大于等于0！
endif
if print_title_of_data = 1
	appendInfoLine: "consonant	dot1	dot2	dot3	dot4	dot5	dot6	dot7	dot8	dot9	dot10	dot11	dot12	dot13	dot14	dot15	dot16	dot17	dot18	dot19	dot20	duration	file	start	end"
endif

duration = Get selection length
timeStart = Get start of selection
timeEnd = Get end of selection
Extract selected sound (preserve times)
endeditor
hertzStart = hertz_start
hertzEnd = Get sampling frequency
fileName3$ = selected$("Sound")
file = 0
if hertzEnd > 20000
	Resample... 20000 50
	hertzEnd = Get sampling frequency
	file = 1
endif
if hertzEnd < 20000
	temp = hertzEnd / 2
	appendInfoLine: "录音文件采样率小于20000Hz，频带能量曲线数据在'temp'~10000赫兹以上的会存在问题。"
endif
hertzEnd = floor (hertzEnd / 2)
fileName2$ = selected$("Sound")
Bei 修改0
hertzStep = floor((hertzEnd - hertzStart) / 20)
createDirectory: legacyDataDirectory$
print 'consonant$'
fileappend "'legacyDataDirectory$'/energy.txt" 'consonant$'
for i from 1 to 20
	binStart = Bei Spectrum2... hertzStart
	binEnd = Bei Spectrum2... hertzStart+hertzStep
	dB = 0
	k = 0
	for j from binStart to binEnd
		dBTemp = Bei 功率谱分贝值... j
		dB = dB + dBTemp
		k = k + 1
	endfor
	hertzStart = hertzStart + hertzStep
	dB = dB / k
	if include_first_band = 1
		print 'tab$''dB:1'
		fileappend "'legacyDataDirectory$'/energy.txt" 'tab$''dB:1'
	elsif include_first_band = 0
		if i = 1
			print 'tab$'
			fileappend "'legacyDataDirectory$'/energy.txt" 'tab$'
		elsif i >= 2
			print 'tab$''dB:1'
			fileappend "'legacyDataDirectory$'/energy.txt" 'tab$''dB:1'
		endif
	endif
endfor

print 'tab$''duration:3''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
fileappend "'legacyDataDirectory$'/energy.txt" 'tab$''duration:3''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
printline
fileappend "'legacyDataDirectory$'/energy.txt" 'newline$'
select Sound 'fileName2$'
plus Spectrum 'fileName2$'
if file = 1
	plus Sound 'fileName3$'
endif
Remove
select Sound 'fileName$'
editor Sound 'fileName$'
#until 0 > 1

