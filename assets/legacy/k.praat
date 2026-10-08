legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是向声学元音图（F1赫兹线性刻度，F2赫兹对数刻度或者F1和F2均为Bark刻度）中添加元音。
#请在声音编辑器点将鼠标放置待测点处，点击"共振峰"下的"Bei向声学元音图中添加元音"。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.04.01

form set parameters
	boolean erase_all
	choice type_of_picture 2
		button F1(Hz)_F2(log(Hz))
		button F1(Bark)_F2(Bark)
	sentence ipa 
endform
if ipa$ = ""
	exit 请输入所测元音的音标或代表符号！
endif
f1 = Get first formant
f2 = Get second formant
endeditor
fileName$ = selected$("Sound")
if erase_all = 1
	Erase all
endif
if type_of_picture = 1
	Axes: log10(3500), log10(500), 1000, 200
Draw inner box
Text left: "yes", "F1 (Hz)"
Text bottom: "yes", "F2 (Hz)"
elsif type_of_picture = 2
	Axes: hertzToBark(3500), hertzToBark(500), hertzToBark(1000), hertzToBark(200)
Draw inner box
Text left: "yes", "F1 (Bark)"
Text bottom: "yes", "F2 (Bark)"
endif
if type_of_picture = 1
	Text special... log10(f2) Centre 'f1' Half Times 12 0 'ipa$'
elsif type_of_picture = 2
	Text special... hertzToBark(f2) Centre hertzToBark(f1) Half Times 12 0 'ipa$'
endif
editor Sound 'fileName$'