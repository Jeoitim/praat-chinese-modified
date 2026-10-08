legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是撤销上一步共振峰数据。
#请在声音编辑器中运行本脚本.
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.03.06

endeditor
fileName$ = selected$()
Read Strings from raw text file... 'legacyDataDirectory$'\vowel.txt
clearinfo
numberOfStrings = Get number of strings
if numberOfStrings = 1
system del 'legacyDataDirectory$'\vowel.txt
printline 撤销上一步共振峰数据成功！
select Strings vowel
Remove
elsif numberOfStrings != 1
Extract part... 1 'numberOfStrings'-1
Save as raw text file... 'legacyDataDirectory$'\vowel.txt
numberOfStrings = Get number of strings
for i from 1 to numberOfStrings
value$ = Get string... i
printline 'value$'
endfor
printline 撤销上一步共振峰数据成功！
Remove
select Strings vowel
Remove
endif
select 'fileName$'
editor 'fileName$'