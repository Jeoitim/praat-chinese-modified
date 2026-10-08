legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据临界频带值求赫兹范围。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.11.03

form set parameters
	natural band 1
endform
if band > 24
	exit band必须小于等于24
endif
clearinfo
hertzStart = barkToHertz(band-1)
hertzEnd = barkToHertz(band)
printline 第'band'个临界频带(四舍五入，Hz)：'hertzStart:0'~'hertzEnd:0'
