# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明（beixianming@163.com）编写。
#本脚本的功能是根据功率谱图修改PitchTier编辑器中的基频曲线并测量。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.10.21

form set parameters
	text 注意： 平调、降调可不修改，PitchTier会自动连线，在那里可以测量
	text 注意： 曲折调及具有凹凸特点的声调曲线断了，测量时需修改
	text 说明： 请将声音编辑器右下角的"Group"勾选上。
	positive maximum_formant 5000
	natural dots_number 3
endform
Spectrogram settings... 70 800 0.03 70
Pitch settings... 70 800 Hertz cross-correlation automatic
pause 请观察并选择需要修改基频的区间。
timeStart = Get start of selection
timeEnd = Get end of selection
if timeEnd - timeStart = 0
	exit 您还没有选择需要修改基频的区间。
endif
timeStep = (timeEnd - timeStart) / (dots_number + 2 - 1)
time = timeStart + timeStep
pitchMax = Get maximum pitch
pitchMax$ = "'pitchMax'"
if pitchMax$ = "--undefined--"
	pitchMax = 300
endif
endeditor
fileName$ = selected$("Sound")
select Sound 'fileName$'
To Pitch... 0.020 70 800
Down to PitchTier
Remove points between... 'timeStart' 'timeEnd'
for i from 1 to dots_number
	editor Sound 'fileName$'
	dBMax = -999999999
	Move cursor to... time
	View spectral slice
	endeditor
	time$ = "'time:3'"
	time$ = replace$(time$, ".", "_", 0)
	fileNameSlice$ = "'fileName$'" + "_" + "'time$'"
	Edit
	editor Spectrum 'fileNameSlice$'
	Zoom... 50 600
	Move cursor to... pitchMax+20
	pause 请确保光标位于第一分音峰值和其后波谷间，dB值不超过峰值。
	frequencyMax = Get cursor
	endeditor
	binMin = Get bin from frequency... 50
	binMin = floor (binMin)
	binMax = Get bin from frequency... frequencyMax
	binMax = ceiling (binMax)
	for j from binMin to binMax
		dBTemp = Bei 功率谱分贝值... j
		if dBMax < dBTemp
			dBMax = dBTemp
			pitch = Get frequency from bin... j
		endif
	endfor
	endeditor
	select PitchTier 'fileName$'
	Add point... 'time' 'pitch'
	time = time + timeStep
	select Spectrum 'fileNameSlice$'
	Remove
endfor
select Sound 'fileName$'
editor Sound 'fileName$'
Spectrogram settings... 0 'maximum_formant' 0.005 70
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
pause 请在PitchTier编辑器点击"查询"下的"Bei 测量基频"
endeditor
select PitchTier 'fileName$'
Remove
select Sound 'fileName$'
editor Sound 'fileName$'