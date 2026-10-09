# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量基频数据，并将数据自动保存到软件所在文件夹下的data\tone.txt中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.02.24

#repeat;如果一个文件要测量多次，例如语调，则开放。
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
fileReadable = fileReadable("'legacyDataDirectory$'/toneIPA.txt")
if fileReadable = 1
	endeditor
	Read from file: "'legacyDataDirectory$'/toneIPA.txt"
	row = Search column: "tone", fileName$
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
	sentence: "tone", ipa$
clicked = endPause: "继续", 1
editor Sound 'fileName$'
if tone$ = "tone" or tone$ = ""
	exit please set parameters correctly
endif
if print_title_of_data = 1
	appendInfoLine: "tone	dot1	dot2	dot3	dot4	dot5	dot6	dot7	dot8	dot9	duration	file	start	end"
endif
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
value$ = H测量基频
duration = Get selection length
timeStart = Get start of selection
timeEnd = Get end of selection
if value$ = "	请选择一段语音。"
	exit 您未选择基频曲线。
endif
x = index(value$,"--undefined--")
if x != 0
	exit 您选择的区域越出基频曲线的范围，请重新选择！
elsif x = 0
	value$ = value$ - "	"
	value$ = tone$ + value$
	createDirectory: legacyDataDirectory$
	fileappend "'legacyDataDirectory$'/tone.txt" 'value$''tab$''duration:3''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4''newline$'
	printline 'value$''tab$''duration:3''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
endif
#until 0 > 1
