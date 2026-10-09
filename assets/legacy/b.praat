# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量共振峰F1、F2、F3数据，并将数据自动保存到软件所在文件夹下的data\vowel.txt中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.02.24

#repeat;如果一个文件要测量多次，例如语调，则开放。
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
fileReadable = fileReadable("'legacyDataDirectory$'/vowelIPA.txt")
if fileReadable = 1
	endeditor
	Read from file: "'legacyDataDirectory$'/vowelIPA.txt"
	row = Search column: "vowel", fileName$
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
	sentence: "vowel", ipa$
clicked = endPause: "继续", 1
editor Sound 'fileName$'

if vowel$ = "vowel" or vowel$ = ""
	exit please set parameters correctly
endif
temp$ = left$(vowel$, 1)
if temp$ = "/"
pause 您输入的第一个为"/"，不是代码中的"\"，是否继续？
endif
vowel$ = backslashTrigraphsToUnicode$(vowel$)
vowel$ = replace$(vowel$, "（", "(", 0)
vowel$ = replace$(vowel$, "）", ")", 0)
index = index(vowel$,"-")
if index = 3
	right$ = right$(vowel$, 1)
	vowel$ = vowel$ - right$(vowel$, 2)
	if right$ = "1"
		vowel$ = left$(vowel$, 1) + "(" + mid$(vowel$, 2, 1) + ")"
	elsif right$ = "2"
		vowel$ = "(" + left$(vowel$, 1) + ")" + mid$(vowel$, 2, 1)
	endif
endif
if index = 4
	right$ = right$(vowel$, 1)
	vowel$ = vowel$ - right$(vowel$, 2)
	if right$ = "1"
		vowel$ = left$(vowel$, 1) + "(" + mid$(vowel$, 2, 2) + ")"
	elsif right$ = "2"
		vowel$ = "(" + left$(vowel$, 1) + ")" + mid$(vowel$, 2, 1) + "(" + mid$(vowel$, 3, 1) + ")"
	elsif right$ = "3"
		vowel$ = "(" + mid$(vowel$, 1, 2)  + ")" + mid$(vowel$, 3, 1)
	endif
endif

if print_title_of_data = 1
	appendInfoLine: "vowel	F1	F2	F3	file	cursor"
endif
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
value$ = H测量共振峰
if value$ = "共振峰测量只需选择时间点，无需选择时间段，请重新选择"
	exit please select area correctly
endif
f3 = Get third formant
f3$ = fixed$('f3',0)
cursor = Get cursor
cursor$ = fixed$('cursor',4)
value$ = vowel$ + value$ + tab$ + f3$ + tab$ + fileName$ + tab$ + cursor$
createDirectory: legacyDataDirectory$
fileappend "'legacyDataDirectory$'/vowel.txt" 'value$''newline$'
printline 'value$'
#until 0 > 1
