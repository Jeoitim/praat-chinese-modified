legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是按调查表格（txt文件）内容录音，一次录一行。声音文件以wav格式保存在praat汉化修改版所在文件夹下的sound文件夹中。如果调查表格是用鼠标右键方式打开的，则录音文件保存在调查表格所在文件夹下的sound文件夹中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#本脚本可在mac系统上运行。
#2019.02.24

form set parameters
	comment 注意：若未录完表格内容，请勿移动praat汉化修改版。
	positive fontSize 60
	positive duration 3
	positive intensityMax 0.99
	positive intensityMin 0.15
	positive samplingFrequency 44100
endform

if intensityMax > 1
	exit intensityMax最好不要大于1。
endif
file$ = chooseReadFile$ ("请选择调查表格")
if file$ = ""
	exit 您还没选择有关调查表格！
elsif file$ <> ""
Read Strings from raw text file... 'file$'
fileName$ = selected$("Strings")
numberOfStrings = Get number of strings
Erase all
createDirectory: legacyDataDirectory$ + "/sound"
for i from 1 to numberOfStrings
	if i < 10
		j$ = "000" + "'i'"
	elsif i >= 10 and i < 100
		j$ = "00" + "'i'"
	elsif i >= 100 and i < 1000
		j$ = "0" + "'i'"
	else
		j$ = "'i'"
	endif
	select Strings 'fileName$'
	strings$ = Get string... i
	strings$ = replace$(strings$," ","",0)
	strings$ = replace$(strings$,"	","",0)
	fileReadable = fileReadable ("'legacyDataDirectory$'/sound/'j$''strings$'.wav")
	if fileReadable != 1
		Select outer viewport: 0, 6, 0, 4
		Axes... 0 1 0 1
		Black
		Text special... 0.5 centre 0.5 half Times 'fontSize' 0 'strings$'
		pause 请点击"继续"，录音。
		if samplingFrequency = 44100
			#praat 6.1.09的bug:用Record Sound (fixed time)录音，采样率不能为44100Hz，否则会卡死。
			#所以先录成48000Hz，保存之前再重新采样。
			samplingFrequencyTemp = 48000
			Record Sound (fixed time)... Microphone 0.5 0.5 'samplingFrequencyTemp' 'duration'
		else
			Record Sound (fixed time)... Microphone 0.5 0.5 'samplingFrequency' 'duration'
		endif
		max = Get maximum... 0 0 None
		min = Get minimum... 0 0 None
		maxStart = Get maximum... 0 0.010 None
		minStart = Get minimum... 0 0.010 None
		maxEnd = Get maximum... 'duration'-0.010 'duration' None
		minEnd = Get minimum... 'duration'-0.010 'duration' None
		Erase all
		Blue
		Draw... 0 0 -1 1 yes Curve
		Marks bottom every... 1 1 yes yes no
		One mark left... 0.15 yes yes yes 0.15
		One mark left... -0.15 yes yes yes -0.15
		Axes... 0 1 0 1
		Black
		Text special... 0.02 left 0.02 bottom Times 'fontSize'/3 0 'strings$'
		Text special... 0.98 right 0.02 bottom Times 'fontSize'/6 0 第'i'个

		if max >= intensityMax or abs(min) >= intensityMax
			exit 录音音量太大，请重录。
		endif
		if max < intensityMin or abs(min) < intensityMin
			exit 录音音量太小，请重录。
		endif
		#if maxStart > intensityMin or abs(minStart) > intensityMin
			#exit 录音开始部分音量太大，请重录。
		#endif
		#if maxEnd > intensityMin or abs(minEnd) > intensityMin
			#exit 录音结束部分音量太大，请重录。
		#endif
		pause 请检查波形，若有问题，重新启动。若无问题，点击"继续"。
		Erase all
		if samplingFrequency = 44100
			Resample... 44100 50
		endif
		Rename... 'i''strings$'
        Save as WAV file: legacyDataDirectory$ + "/sound/" + j$ + strings$ + ".wav"
		Remove
		if samplingFrequency = 44100
			select Sound untitled
			Remove
		endif
	endif
endfor
endif
exit 录音完毕！

