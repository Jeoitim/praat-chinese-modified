legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是打开指定的文件夹。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2020.08.30

form set parameters
	choice open_path 2
	button praat汉化修改版所在的文件夹
	button praat汉化修改版\data
	button praat汉化修改版\sound
	button praat汉化修改版首选项目录
	button other_path
	sentence other_path c:\
endform
if open_path = 1
	system start 'applicationDirectory$'
	#此句亦可runSystem("start 'applicationDirectory$'")
elsif open_path = 2
	system start 'legacyDataDirectory$'
elsif open_path = 3
	system start 'legacyDataDirectory$'\sound
elsif open_path = 4
	system start 'preferencesDirectory$'
elsif open_path = 5
	if index("http", other_path$) != 0
		other_path$ = replace$(other_path$, "&", "%26", 0)
	endif
	system start 'other_path$'
endif
