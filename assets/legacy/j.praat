if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
# 1.本脚本由贝先明（beixianming@163.com）编写，用来绘制语调曲线图，已经通过praat汉化修改版测试。
# 2.请读入声音文件、标注（TextGrid）文件（如果有的话），然后在praat主编辑器窗口运行这个脚本。
# 3.画图时是否要删除图片编辑器中原有的图片、是否有TextGrid文件参与作图这两种功能请读者根据实际情况选用。
#2019.02.24

form set parameters
	positive pitch_floor 64
	positive pitch_ceiling 362
	real time_start 0
	real time_end 0
	choice scale 1
		button Semitones
		button Hertz
	boolean erase_picture_already_existed?
	boolean draw_with_textGrid?
	sentence name_of_picture_to_be_saved 语调图
endform
fileName$ = selected$("Sound")
if 'erase_picture_already_existed?' = 1
	Erase all
endif
if time_end = 0
	time_end = Get total duration
endif
To Pitch... 0 pitch_floor pitch_ceiling+120
pause please modify pitch curver by View & Edit, then click Continue.
numberOfFrames = Get number of frames
if scale = 1
	appendInfoLine: "时间", tab$, "半音(参考频率=64赫兹)"
elsif scale = 2
	appendInfoLine: "时间", tab$, "赫兹"
endif
for i to numberOfFrames
	time = Get time from frame number: i
	if scale$ = "Hertz"
		value = Get value at time: time, "Hertz", "Linear"
		appendInfoLine: fixed$ (time, 3), tab$, fixed$ (value, 0)
	elsif scale$ = "Semitones"
		value = Get value at time: time, "semitones re 64 Hz", "Linear"
		appendInfoLine: fixed$ (time, 3), tab$, fixed$ (value, 1)
	endif
endfor
Line width... 1.5
Black
if scale$ = "Hertz"
	if 'draw_with_textGrid?' = 0
		Draw... time_start time_end pitch_floor pitch_ceiling "yes"
	elsif 'draw_with_textGrid?' = 1
		pause draw with textGrid? please open it and select both textGrid and pitch file.
		Draw... 1 time_start time_end pitch_floor pitch_ceiling 12 "yes" "Centre" "yes"
	endif
elsif scale$ = "Semitones"
	if 'draw_with_textGrid?' = 0
		Draw semitones (re 64 Hz)... time_start time_end hertzToSemitonesRe64(pitch_floor) hertzToSemitonesRe64(pitch_ceiling) "yes"
	elsif 'draw_with_textGrid?' = 1
		pause draw with textGrid? please open it and select both textGrid and pitch file.
		Draw semitones (Re64)... 1 time_start time_end hertzToSemitonesRe64(pitch_floor) hertzToSemitonesRe64(pitch_ceiling) 12 "yes" "Centre" "yes"
	endif
endif
Line width... 1
Draw inner box
Marks bottom... 11 yes yes no
Marks left... 6 "yes" "yes" "yes"
if scale$ = "Hertz"
	Text left... "yes" Pitch (Hz)
elsif scale$ = "Semitones"
	Text left... "yes" Pitch (semitones  %r%e  64 Hz)
endif
Text bottom... "yes" Time (s)
Text special... time_end "centre" pitch_floor-3 "top" "Times" 12 "0" 'time_end:3'
createDirectory: legacyDataDirectory$
i = fileReadable("'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'")
if i = 1
	pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if windows
    Save as 600-dpi PNG file... 'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'
else
    Save as PDF file... 'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'
endif
Remove
select Sound 'fileName$'
# 脚本结束
