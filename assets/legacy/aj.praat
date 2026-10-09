# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明（beixianming@163.com）编写。
#本脚本的功能是计算辅音的谱重心和分散程度。 
#请务必保持采样率大于10010×2＝20020Hz或以上。
#2019.10.29

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
	comment: "注意：采样率需大于等于20020Hz，高频区域才有计算意义。"
	comment: "注意：分析塞音时，务必正确选择好冲直条的范围。"
	comment: "注意：one_dots适合所有的语音片段。"
	comment: "注意：fixed_timestep适合于时长大于等于0.010秒的语音片段。"
	comment: "注意：three_dots适合时长大于等于0.030秒的语音片段。较少用。"
	boolean: "print_title_of_data", 0
	boolean: "erase_all", 0
	boolean: "draw", 0
	choice: "dot", 2
		option: "one_dot"
		option: "fixed_timestep"
		option: "three_dots"
	sentence: "consonant", ipa$
clicked = endPause: "继续", 1
consonant$ = backslashTrigraphsToUnicode$(consonant$)
editor Sound 'fileName$'
if consonant$ = "consonant" or consonant$ = ""
	exit 请输入音标
endif
if print_title_of_data = 1
	appendInfoLine: "consonant	gravity	dispersion	centreOfGravity	file	start	end"
endif
timeStart = Get start of selection
timeEnd = Get end of selection
timeAll = timeEnd - timeStart
endeditor
samplingFrequency = Get sampling frequency
if samplingFrequency < 20020
	Resample... 20020 50
	Rename... 'fileName$'
endif
if erase_all = 1
	Erase all
endif
if draw = 1
	Axes... 0 8 0 24
	Draw inner box
	Text left... yes %Gravity
	Text bottom... yes %Dispersion
	Marks left every... 1 2 yes yes yes
	Marks bottom every... 1 1 yes yes yes
endif

if dot = 1
	endeditor
	createDirectory: legacyDataDirectory$
	select Sound 'fileName$'
	editor Sound 'fileName$'
	if timeAll = 0
		Select... timeStart-0.005 timeEnd+0.005
	endif
	Extract selected sound (windowed)... slice rectangular 1 yes
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
	printline 'consonant$''tab$''energyDistribution$''tab$''centreOfGravity:0''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
	fileappend "'legacyDataDirectory$'/energyDistribution.txt" 'consonant$''tab$''energyDistribution$''tab$''centreOfGravity:0''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4''newline$'
	if draw = 1
		length0 = length(energyDistribution$)
		position0 = index(energyDistribution$,"	")
		m$ = left$(energyDistribution$,position0-1)
		s$ = right$(energyDistribution$,length0-position0)
		m = 'm$'
		s = 's$'
		Text special... 's' Centre 'm' Half Times 10 0 'consonant$'
	endif

elsif dot = 2
	if timeAll = 0
		#下句为了跳出repeat
		time_step = 0.0001
	elsif timeAll >= 0.010 
		time_step = 0.010
	elsif timeAll > 0 and timeAll < 0.010
		#下句为了跳出repeat
		time_step = timeAll+0.0001
	endif
	time = timeStart
	endeditor
	createDirectory: legacyDataDirectory$
	repeat
		select Sound 'fileName$'
		editor Sound 'fileName$'
		if timeAll = 0
			Select... timeStart-0.005 timeEnd+0.005
		elsif timeAll >= 0.010
			Select... time time+time_step
		elsif timeAll > 0 and timeAll < 0.010
			Select... timeStart timeEnd
		endif
		Extract selected sound (windowed)... slice rectangular 1 yes
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
	printline 'consonant$''tab$''energyDistribution$''tab$''centreOfGravity:0''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
	fileappend "'legacyDataDirectory$'/energyDistribution.txt" 'consonant$''tab$''energyDistribution$''tab$''centreOfGravity:0''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4''newline$'
	if draw = 1
		length0 = length(energyDistribution$)
		position0 = index(energyDistribution$,"	")
		m$ = left$(energyDistribution$,position0-1)
		s$ = right$(energyDistribution$,length0-position0)
		m = 'm$'
		s = 's$'
		Text special... 's' Centre 'm' Half Times 10 0 'consonant$'
	endif
	time = time + time_step
	until time > timeEnd

elsif dot = 3
	if timeAll >= 0.030
		#3段非3点，所以要除以3而不是除以2！
		time_step = timeAll / 3
	else
 		#下句为了保证for能正常运行
		time_step = timeAll+0.0001
	endif
	time = timeStart
	endeditor
	createDirectory: legacyDataDirectory$
	for k from 1 to 3
		select Sound 'fileName$'
		editor Sound 'fileName$'
		if timeAll = 0
			Select... timeStart-0.005 timeEnd+0.005
		elsif timeAll >= 0.030
			Select... time time+time_step
		elsif timeAll > 0 and timeAll < 0.030
			Select... timeStart timeEnd
		endif
		Extract selected sound (windowed)... slice rectangular 1 yes
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
		printline 'consonant$''tab$''energyDistribution$''tab$''centreOfGravity:0''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
		fileappend "'legacyDataDirectory$'/energyDistribution.txt" 'consonant$''tab$''energyDistribution$''tab$''centreOfGravity:0''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4''newline$'
		if draw = 1
			length0 = length(energyDistribution$)
			position0 = index(energyDistribution$,"	")
			m$ = left$(energyDistribution$,position0-1)
			s$ = right$(energyDistribution$,length0-position0)
			m = 'm$'
			s = 's$'
			Text special... 's' Centre 'm' Half Times 10 0 'consonant$'
		endif
		time = time + time_step
	endfor
endif

select all
minus Sound 'fileName$'
Remove
select Sound 'fileName$'
editor Sound 'fileName$'
if timeAll = 0
	Move cursor to... timeStart
elsif timeAll > 0
	Select... timeStart timeEnd
endif
#until 0 > 1
