legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是录制摄像头、声卡和麦克风。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2022.11.12

form set parameters
	comment 注意：按q结束录制
	comment 注意：首次运行菜单请勿勾选video789.bat and camera already exist
	sentence microphone1 麦克风阵列 (Realtek High Definition Audio)
	sentence microphone2 麦克风阵列 (Realtek High Definition Audio)
	sentence camera1 Integrated Camera
	sentence camera2 Integrated Camera
	positive bufsize 500
	sentence watermark bei
	sentence fontcolor red
	positive fontsize 50
	sentence filename myvideo.mp4
	boolean many_video 0
	boolean video789.bat_and_camera.bat_already_exist 1
endform

fileReadable = fileReadable(filename$)
if fileReadable = 1
	exit 视频文件已存在，请换一个文件名！
endif
if video789.bat_and_camera.bat_already_exist = 0
	do1$ = "'applicationDirectory$'\ffplay.exe -f dshow -i video=" + unicode$(34) + camera1$ + unicode$(34)
	do2$ = "'applicationDirectory$'\ffmpeg.exe -rtbufsize " + "'bufsize'" + "M -thread_queue_size 1024 -f dshow -i audio=" + unicode$(34) + microphone1$ + unicode$(34) + " -rtbufsize " + "'bufsize'" + "M -thread_queue_size 1024 -f dshow -i audio=" + unicode$(34) + microphone2$ + unicode$(34) + " -filter_complex amix=inputs=2:duration=first:dropout_transition=2 -rtbufsize " + "'bufsize'" + "M -thread_queue_size 1024 -f dshow -i video=" + unicode$(34) + camera2$ + unicode$(34) + " -pix_fmt yuv420p -vf drawtext=" + unicode$(34) + "fontcolor=" + fontcolor$ + ":fontsize=" + "'fontsize'" + ":fontfile='msyh.ttf':text='" + watermark$ + "':x=50:y=50" + unicode$(34) + " -y " + applicationDirectory$ + "\" +  filename$
	Text writing preferences: "try ISO Latin-1, then UTF-16"
	dosPath$ = "set path=" + applicationDirectory$ + ";%path%"
	writeFileLine: "'applicationDirectory$'\camera.bat", do1$
	appendFileLine: "'applicationDirectory$'\camera.bat", "exit"
	writeFileLine: "'applicationDirectory$'\video789.bat", dosPath$
	appendFileLine: "'applicationDirectory$'\video789.bat", do2$
	appendFileLine: "'applicationDirectory$'\video789.bat", "exit"
	pause 右键单击video789.bat，编辑-文件-另存为-编码选ANSI
endif
runSystem: "start 'applicationDirectory$'\camera.bat"
pause 如若camera1和camera2不同，按继续；若相同，请按q，再按继续。
if many_video = 0
	runSystem: "start 'applicationDirectory$'\video789.bat"
elsif many_video = 1
	times = 0
	position = length(filename$) - rindex(filename$, ".") + 1
	filename0$ = filename$ - right$(filename$,position)
	filetype$ = right$(filename$,position)
	repeat
		runSystem: "start 'applicationDirectory$'\video789.bat"
		times = times + 1
		runSystem: "rename 'applicationDirectory$'\'filename$' 'filename0$''times''filetype$'"
		pause 请继续
	until 0 > 1
endif
if video789.bat_and_camera.bat_already_exist = 0
	Text writing preferences: "UTF-8"
endif
clearinfo
printline 【温馨提示】
printline 查看可用的音视频录制设备：ffmpeg -list_devices true -f dshow -i dummy




