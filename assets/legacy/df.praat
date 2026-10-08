legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是录制屏幕和麦克风。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2022.11.12

form set parameters
	comment 注意：按q结束录制
	comment 注意：首次运行菜单请勿勾选video456.bat already exist
	sentence microphone 麦克风阵列 (Realtek High Definition Audio)
	positive bufsize 500
	sentence watermark bei
	sentence fontcolor red
	positive fontsize 50
	sentence filename myvideo.mp4
	boolean video456.bat_already_exist 1
endform

fileReadable = fileReadable(filename$)
if fileReadable = 1
	exit 视频文件已存在，请换一个文件名！
endif
if video456.bat_already_exist = 0
	do$ = "'applicationDirectory$'\ffmpeg.exe  -f dshow -i audio=" + unicode$(34) + microphone$ + unicode$(34) + "  -rtbufsize " + "'bufsize'" +"M -thread_queue_size 1024 -f gdigrab -i desktop -pix_fmt yuv420p -vf drawtext=" + unicode$(34) + "fontcolor=" + fontcolor$ + ":fontsize=" + "'fontsize'" + ":fontfile='msyh.ttf':text='" +watermark$ +"':x=50:y=50" + unicode$(34) + " -y " + applicationDirectory$ + "\" + filename$
	Text writing preferences: "try ISO Latin-1, then UTF-16"
	dosPath$ = "set path=" + applicationDirectory$ + ";%path%"
	writeFileLine: "'applicationDirectory$'\video456.bat", dosPath$
	appendFileLine: "'applicationDirectory$'\video456.bat", do$
	appendFileLine: "'applicationDirectory$'\video456.bat", "exit"
	pause 右键单击video456.bat，编辑-文件-另存为-编码选ANSI
endif
runSystem: "start 'applicationDirectory$'\video456.bat"
if video456.bat_already_exist = 0
	Text writing preferences: "UTF-8"
endif
clearinfo
printline 【温馨提示】
printline 查看可用的音视频录制设备：ffmpeg -list_devices true -f dshow -i dummy





