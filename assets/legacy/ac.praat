legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量基频数据，并将数据自动保存到软件所在文件夹下的data\tone.txt中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.09.01

form set parameters
sentence tone 
endform

if tone$ = "tone" or tone$ = ""
exit please set parameters correctly
endif
editorInfo$ = Editor info
fileName$ = extractWord$(editorInfo$,"Data name:")
duration = Get selection length
if duration = 0
exit 您未选择基频曲线。
endif
timeStart = Get start of selection
timeEnd = Get end of selection
timeStep = (timeEnd - timeStart) / 8
time = timeStart
for i from 1 to 9
Move cursor to... time
value'i' = Get pitch
value = value'i'
value$ = "'value'"
if value$ = "--undefined--"
exit 您选择的区域越出基频曲线的范围，请重新选择！
endif
time = time + timeStep
endfor
createDirectory: legacyDataDirectory$
fileappend "'legacyDataDirectory$'/tone.txt" 'tone$''tab$''value1:0''tab$''value2:0''tab$''value3:0''tab$''value4:0''tab$''value5:0''tab$''value6:0''tab$''value7:0''tab$''value8:0''tab$''value9:0''tab$''duration:3''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4''newline$'
printline 'tone$''tab$''value1:0''tab$''value2:0''tab$''value3:0''tab$''value4:0''tab$''value5:0''tab$''value6:0''tab$''value7:0''tab$''value8:0''tab$''value9:0''tab$''duration:3''tab$''fileName$''tab$''timeStart:4''tab$''timeEnd:4'
Select... timeStart timeEnd


