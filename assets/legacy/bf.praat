legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是收集听辨的选择结果和反应时间。
#辨认实验中，内容提示.txt中的词对必须和实际播放语音文件的数量和顺序一致。
#内容提示.txt和相关的wav文件均位于相同的文件夹。
#内容提示.txt的第一行标题必须是“wav文件名	屏幕提示内容”。
#反应时间从声音播放完毕开始计算，如果测量某个反映时间为负值（如-0.050秒），说明本次按键在声音尚未播放完毕的情况（如提前了-0.050秒）按下的。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2020.12.23

form set parameters
	sentence 注意 辨认实验中，提示内容.txt中的词对必须和实际播放语音文件的数量和顺序一致
	sentence 注意 内容提示.txt和相关的wav文件均位于相同的文件夹
	sentence 注意 内容提示.txt的第一行标题必须是“wav文件名	屏幕提示内容”
	sentence 注意 反应时间从声音播放完毕开始计算，如果测量某个反映时间为负值（如-0.050秒），说明本次按键在声音尚未播放完毕的情况（如提前了-0.050秒）按下的。
	sentence 注意 声音文件首尾不需留空白，两个文件中间的停顿通过time_step设定
	sentence file_path .
	positive time_interval 0.400
	positive time_step 2.000
	choice type 1
	button distinguish
	button identify
	boolean sounds_have_concatenated 0
endform
if file_path$ = "."
    file_path$ = legacyDataDirectory$
endif

x = fileReadable("'legacyDataDirectory$'/听觉实验.txt")
if x = 1
	pause 听觉实验.txt已经存在，请将其先移走，否则数据会追加到其中！
endif
fileappend "'legacyDataDirectory$'/听觉实验.txt" 序号'tab$'文件名'tab$'声音时长(s)'tab$'选择'tab$'反应时间(s)'newline$'
demo Erase all
demo Select inner viewport: 0, 100, 0, 100
demo Axes: 0, 100, 0, 100
demo Paint rectangle: "blue", 0, 100, 0, 100
demo White

select all
nocheck Remove
Read from file... 'file_path$'/内容提示.txt
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	select Table 内容提示
	fileName1$ = Get value: i, "wav文件名"
	fileNameTemp1$ = fileName1$ + ".wav"
	fileName$ = fileName1$
	if sounds_have_concatenated = 0 and type = 1
		if i = numberOfRows
			demo Erase all
			demo Blue
			demo Text special: 50, "Centre", 50, "Half", "Times", 40, "0", "听辨实验完成，谢谢您！"
			exit
		endif
		fileName2$ = Get value: i+1, "wav文件名"
		fileNameTemp2$ = fileName2$ + ".wav"
	endif
	Read from file... 'file_path$'/'fileNameTemp1$'
	if sounds_have_concatenated = 0 and type = 1
		numberOfChannels = Get number of channels
		samplingFrequency = Get sampling frequency
		Create Sound as pure tone: "interval", numberOfChannels, 0, time_interval, samplingFrequency, 440, 0.2, 0.01, 0.01
		Set part to zero: 0, 0, "at nearest zero crossing"
		Read from file... 'file_path$'/'fileNameTemp2$'
		select all
		minus Table 内容提示
		Concatenate
		fileName$ = fileName1$ + fileName2$
	endif
	duration = Get total duration
	if type = 1
		demoShow ( )
		demo Text special: 50, "Centre", 50, "Half", "Times", 40, "0", "相同    不同"
		demo Text special: 50, "Centre", 40, "Half", "Times", 40, "0", " F       J  "
	elsif type = 2
		select Table 内容提示
		words$ = Get value: i, "屏幕提示内容"
		words$ = replace$(words$, "，", "    ", 0)
		words$ = replace$(words$, ",", "    ", 0)
		demoShow ( )
		demo Erase all
		demo Paint rectangle: "blue", 0, 100, 0, 100
		demo Text special: 50, "Centre", 50, "Half", "Times", 40, "0", "'words$'"
		demo Text special: 50, "Centre", 40, "Half", "Times", 40, "0", " F       J  "
		if sounds_have_concatenated = 0 and type = 1
			select Sound chain
		else
			select Sound 'fileName1$'
		endif
	endif
	asynchronous Play
	stopwatch
	demoWaitForInput ( )
	if demoClicked ( )
		exit 请勿点击鼠标。
	elsif demoKeyPressed ( )
		if demoKey$ ( ) = "F" or demoKey$ ( ) = "f"
			key$ = "F"
		elsif demoKey$ ( ) = "J" or demoKey$ ( ) = "j"
			key$ = "J"
		else
			exit 只能按F和J键。
		endif
		time = stopwatch
		time = time - duration
		fileappend "'legacyDataDirectory$'/听觉实验.txt" 'i''tab$''fileName$''tab$''duration:3''tab$''key$''tab$''time:3''newline$'
	endif
	if sounds_have_concatenated = 0 and type = 1
		i = i + 1
		select all
		minus Table 内容提示
	endif
	Remove
	sleep(time_step)
endfor
demo Erase all
demo Blue
demo Text special: 50, "Centre", 50, "Half", "Times", 40, "0", "听辨实验完成，谢谢您！"
select Table 内容提示
Remove

