legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量塞擦音数据，并将数据自动保存到软件所在文件夹下的data\affricate.txt中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.09.30

#repeat;如果一个文件要测量多次，例如语调，则开放。
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
fileReadable = fileReadable("'legacyDataDirectory$'/affricateIPA.txt")
if fileReadable = 1
	endeditor
	Read from file: "'legacyDataDirectory$'/affricateIPA.txt"
	row = Search column: "affricate", fileName$
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
	comment: "请确保采样率在22050Hz及以上"
	boolean: "print_title_of_data", 0
	boolean: "erase_all", 0
	boolean: "draw", 1
	sentence: "affricate", ipa$
clicked = endPause: "继续", 1
affricate$ = backslashTrigraphsToUnicode$(affricate$)
editor Sound 'fileName$'
if affricate$ = "affricate" or affricate$ = ""
	exit please set parameters correctly
endif

timeStart = Get start of selection
timeEnd = Get end of selection
if timeEnd = timeStart
	exit 您还没有选择gap区间。
endif
gap = timeEnd - timeStart
pause 请选择摩擦段区间，然后点击Continue
timeStart = Get start of selection
timeEnd = Get end of selection
if timeEnd = timeStart
	exit 您还没有选择摩擦段区间。
endif
vot = timeEnd - timeStart

endeditor
fileName$ = selected$("Sound")
if erase_all = 1
	Erase all
endif
Axes... 0 8 0 24
Draw inner box
Text left... yes %Friction Index
Text bottom... yes %Duration Index
Marks left every... 1 2 yes yes yes
Marks bottom every... 1 1 yes yes yes
createDirectory: legacyDataDirectory$
select Sound 'fileName$'
editor Sound 'fileName$'
Extract selected sound (windowed)... slice Hamming 1 yes
endeditor
Rename... newsound
To Spectrum... yes
endeditor
centreOfGravity = Get centre of gravity... 2
for j from 2 to 24
	critical_bandstart = Get bin number from frequency... 650*sinh((j-1)/7)+1
	critical_bandend = Get bin number from frequency... 650*sinh(j/7)
	critical_bandstart = round(critical_bandstart)
	critical_bandend = round(critical_bandend)
	dBAll = 0
	for i from critical_bandstart to critical_bandend
		dB = Bei 功率谱分贝值... i
		dBAll = dBAll + dB
	endfor
	x'j' = dBAll / (critical_bandend - critical_bandstart + 1)
endfor
energyDistribution$ = Bei 计算能量分布模式... 'x2' 'x3' 'x4' 'x5' 'x6' 'x7' 'x8' 'x9' 'x10' 'x11' 'x12' 'x13' 'x14' 'x15' 'x16' 'x17' 'x18' 'x19' 'x20' 'x21' 'x22' 'x23' 'x24'
length0 = length(energyDistribution$)
position0 = index(energyDistribution$,"	")
m$ = left$(energyDistribution$,position0-1)
s$ = right$(energyDistribution$,length0-position0)
m = 'm$'
s = 's$'
durationIndex = vot / gap
frictionIndex = m / s
if print_title_of_data = 1
	appendInfoLine: "塞擦音	空白段时长	摩擦段时长	谱重心	离散度	谱重心（Hz）	时长指数	摩擦指数"
endif
printline 'affricate$''tab$''gap:3''tab$''vot:3''tab$''energyDistribution$''tab$''centreOfGravity:0''tab$''durationIndex:2''tab$''frictionIndex:2'
fileappend "'legacyDataDirectory$'/affricate.txt" 'affricate$''tab$''gap:3''tab$''vot:3''tab$''energyDistribution$''tab$''centreOfGravity:0''tab$''durationIndex:2''tab$''frictionIndex:2''newline$'
if draw = 1
	Text special... 'durationIndex' Centre 'frictionIndex' Half Times 10 0 'affricate$'
endif
endeditor
select Sound newsound
plus Spectrum newsound
Remove
select Sound 'fileName$'
editor Sound 'fileName$'
#until 0 > 1