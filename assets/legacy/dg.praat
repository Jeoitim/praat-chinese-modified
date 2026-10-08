legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是录制屏幕、声卡和麦克风。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2022.11.12

form set parameters
	comment 注意：按q结束录制
	comment 注意：首次运行菜单请勿勾选video123.bat already exist
	sentence microphone1 麦克风阵列 (Realtek High Definition Audio)
	sentence microphone2 麦克风阵列 (Realtek High Definition Audio)
	positive bufsize 500
	sentence watermark bei
	sentence fontcolor red
	positive fontsize 50
	sentence filename myvideo.mp4
	boolean video123.bat_already_exist 1
endform

fileReadable = fileReadable(filename$)
if fileReadable = 1
	exit 视频文件已存在，请换一个文件名！
endif
if video123.bat_already_exist = 0
	do$ = "'applicationDirectory$'\ffmpeg.exe -rtbufsize " + "'bufsize'" + "M -thread_queue_size 1024 -f dshow -i audio=" + unicode$(34) + microphone1$ + unicode$(34) + " -rtbufsize " + "'bufsize'" + "M -thread_queue_size 1024 -f dshow -i audio=" + unicode$(34) + microphone2$ + unicode$(34) + " -filter_complex amix=inputs=2:duration=first:dropout_transition=2" +  " -rtbufsize " + "'bufsize'" + "M -thread_queue_size 1024 -f gdigrab -i desktop -pix_fmt yuv420p -vf drawtext=" + unicode$(34) + "fontcolor=" + fontcolor$ + ":fontsize=" + "'fontsize'" + ":fontfile='msyh.ttf':text='" + watermark$ + "':x=50:y=50" + unicode$(34) + " -y " + applicationDirectory$ + "\" + filename$
	Text writing preferences: "try ISO Latin-1, then UTF-16"
	dosPath$ = "set path=" + applicationDirectory$ + ";%path%"
	writeFileLine: "'applicationDirectory$'\video123.bat", dosPath$
	appendFileLine: "'applicationDirectory$'\video123.bat", do$
	appendFileLine: "'applicationDirectory$'\video123.bat", "exit"
	pause 右键单击video123.bat，编辑-文件-另存为-编码选ANSI
endif
runSystem: "start 'applicationDirectory$'\video123.bat"
if video123.bat_already_exist = 0
	Text writing preferences: "UTF-8"
endif
clearinfo
printline 【温馨提示】
printline 查看可用的音视频录制设备：ffmpeg -list_devices true -f dshow -i dummy



