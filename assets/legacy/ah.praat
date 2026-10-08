legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明（beixianming@163.com）编写。
#本脚本的功能是根据声音编辑器中的窄带语图修改PitchTier编辑器中的基频曲线并测量。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.10.21

pause 请选择需要修改基频的曲线区间。
timeStart = Get start of selection
timeEnd = Get end of selection
if timeEnd - timeStart = 0
	exit 您还没有选择需要修改基频的区间。
endif
editorInfo$ = Editor info
formantCeiling1$ = extractWord$(editorInfo$, "Formant maximum formant:")
formantCeiling2$ = extractWord$(editorInfo$, "Formant ceiling:")
if formantCeiling1$ != ""
	formantCeiling = number(formantCeiling1$)
else
	formantCeiling = number(formantCeiling2$)
endif
dynamicRange$ = extractWord$(editorInfo$, "Spectrogram dynamic range:")
dynamicRange = number(dynamicRange$)
Spectrogram settings... 70 800 0.03 70
Pitch settings... 70 800 Hertz cross-correlation automatic
beginPause: "set parameters"
	comment: "1.平调、降调可不修改，PitchTier会自动连线，在那里可以测量。"
	comment: "2.曲折调及具有凹凸特点的声调曲线断了，测量时需修改。"
	comment: "3.请将声音编辑器右下角的 Group 勾选上。"
	natural: "harmonic_number", "1(=谐波的编号)"
	natural: "dots_number", "3(=修改的点数)"
clicked = endPause: "继续", 1
timeStep = (timeEnd - timeStart) / (dots_number + 2 - 1)
time = timeStart + timeStep
endeditor
fileName$ = selected$("Sound")
To Pitch... 0.020 70 800
Down to PitchTier
Remove points between... 'timeStart' 'timeEnd'
for i from 1 to 3
	select Sound 'fileName$'
	editor Sound 'fileName$'
	Move cursor to... time
	pause 请保持鼠标的时刻点，并点击第'harmonic_number'条谐波的中心频率位置。
	hz = Get frequency at frequency cursor
	time = Get cursor
	pitch = hz / harmonic_number
	endeditor
	select PitchTier 'fileName$'
	Add point... 'time' 'pitch'
	time = time + timeStep
endfor
select Sound 'fileName$'
editor Sound 'fileName$'
Spectrogram settings... 0 'formantCeiling' 0.005 'dynamicRange'
Pitch settings... 75 500 Hertz cross-correlation automatic
Select... timeStart timeEnd
pause 请选择需要测量的基频曲线。
endeditor
select Pitch 'fileName$'
Remove
select PitchTier 'fileName$'
Edit
editor PitchTier 'fileName$'
Set frequency range... 70 800
pause 请在PitchTier编辑器点击"查询"下的"Bei 测量基频"，后可保存PitchTier
endeditor
select PitchTier 'fileName$'
Remove
select Sound 'fileName$'
editor Sound 'fileName$'