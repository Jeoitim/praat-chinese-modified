legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是移动光标至指定共振峰段的极值处。
#请读入energyDistribution.txt后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.04.21

form set patameters
	choice speaker 1
		button female
		button male
	choice formant 1
		button F1
		button F2
	choice type 1
		button max
		button min
endform

timeStart = Get start of selection
timeEnd = Get end of selection
if timeEnd = timeStart
	exit 您还没有选择语音片段
endif
info$ = Editor info
editor$ = extractWord$(info$, "Data type:")
fileName$ = extractWord$(info$, "Data name:")
Select... timeStart timeEnd
Extract selected sound (windowed): "slice", "Hamming", 1, "yes"
endeditor
fileNameTemp$ = selected$("Sound")
if speaker = 1
	To Formant (burg)... 0 5 5500 0.025 50
elsif speaker = 2
	To Formant (burg)... 0 5 5000 0.025 50
endif
if formant = 1 and type = 1
	time = Get time of maximum... 1 'timeStart' 'timeEnd' hertz parabolic
elsif formant = 1 and type = 2
	time = Get time of minimum... 1 'timeStart' 'timeEnd' hertz parabolic
elsif formant = 2 and type = 1
	time = Get time of maximum... 2 'timeStart' 'timeEnd' hertz parabolic
elsif formant = 2 and type = 2
	time = Get time of minimum... 2 'timeStart' 'timeEnd' hertz parabolic
endif
Remove
select Sound 'fileNameTemp$'
Remove
select 'editor$' 'fileName$'
editor 'editor$' 'fileName$'
Move cursor to... time
