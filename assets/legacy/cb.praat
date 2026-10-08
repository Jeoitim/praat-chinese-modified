legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是打开常见的几个程序（记事本、word、excel、powerpoint、dos、ie、edge）。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.08.13

form set parameters
	choice open 1
	button 记事本
	button word
	button excel
	button powerpoint
	button dos
	button ie
	button edge
endform
if open = 1
	runSystem: "start notepad"
elsif open = 2
	runSystem: "start winword"
elsif open = 3
	runSystem: "start excel"
elsif open = 4
	runSystem: "start powerpnt"
elsif open = 5
	runSystem: "start cmd"
elsif open = 6
	runSystem: "start iexplore"
elsif open = 7
	runSystem: "start msedge"
endif

