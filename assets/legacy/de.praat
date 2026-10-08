legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是调整录音音量。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2022.11.06

form set parameters
	comment 1.按向上的箭头调大录音的音量。
	comment 2.按向下的箭头调小录音的音量。
	comment 3.每按一次调大或调小2%的音量。
	comment 4.按回车键结束调整。
	comment 5.录音音量下限为0，上限为100。
	choice type 1
		button 通过上下箭头调整
		button 直接将录音音量调为0
		button 直接将录音音量调为100
endform
if type = 1
	runSystem: "start 'applicationDirectory$'\调整录音音量.exe"
elsif type = 2
	runSystem: "start 'applicationDirectory$'\调整录音音量为0.exe"
elsif type = 3
	runSystem: "start 'applicationDirectory$'\调整录音音量为100.exe"
endif