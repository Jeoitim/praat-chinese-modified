legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是提取指定文件夹内标注文件的内容和声学参数，结果保存在name_of_file_to_be_saved textgrid_data.txt中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2020.07.06

form set parameters
	comment 注意 若提取共振峰，请确保声音编辑器的Formant ceiling设置合适
	comment 注意 若提取基频，请确保声音编辑器的Pitch range等设置合适
	sentence file_path .
	sentence sound_file_type wav
	natural number_of_tier 1
	sentence lable_of_silence S(若没标注静音段，务必清空此栏)
	sentence name_of_file_to_be_saved textgrid_data
	choice unit 1
		button duration
		button intensity
		button formant
		button pitch
		button energy
	boolean including_title_of_data_? 0
	boolean including_duration_of_silence_? 0
endform
if file_path$ = "."
    file_path$ = legacyDataDirectory$
endif

Create Strings as file list... fileList 'file_path$'/*.TextGrid
numberOfStrings = Get number of strings
fileReadable=fileReadable("'file_path$'/'name_of_file_to_be_saved$'.txt")
if fileReadable = 1
	pause 'name_of_file_to_be_saved$'.txt已在，请移走，结果将附其中！
endif
for times from 1 to numberOfStrings
	select Strings fileList
	fileName$ = Get string... times
	Read from file... 'file_path$'/'fileName$'
	fileName$ = fileName$ - ".TextGrid"
	i=fileReadable("'file_path$'/'fileName$'.'sound_file_type$'")
	if i = 0
		exit 'file_path$'下不存在'fileName$'.'sound_file_type$'文件，请核实！
	endif
	Read from file... 'file_path$'/'fileName$'.'sound_file_type$'
	call textgrid_data
endfor
select Strings fileList
Remove
date$ = date$()
fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 检索时间：'date$''newline$'
exit 全部提取完毕，请到'file_path$'/'name_of_file_to_be_saved$'.txt查看结果！

procedure textgrid_data
j = 0
fileName$ = selected$("Sound")
Edit
endeditor
select TextGrid 'fileName$'
isIntervalTier = Is interval tier... 'number_of_tier'
if isIntervalTier = 1
	numberOfIntervals = Get number of intervals... number_of_tier
elsif isIntervalTier = 0
	numberOfPoints = Get number of points... number_of_tier
endif

if isIntervalTier = 1
	if unit = 1
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 标注'tab$''tab$'起点'tab$'止点'tab$'时长'tab$'文件名'newline$'
		endif
		for i from 1 to numberOfIntervals
			labelOfInterval$ = Get label of interval... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfInterval$ != "'lable_of_silence$'"
					timeStart = Get start point... number_of_tier i
					timeEnd = Get end point... number_of_tier i
					duration = timeEnd - timeStart
					j = j + 1
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'j'个标注'tab$''labelOfInterval$''tab$''timeStart:3''tab$''timeEnd:3''tab$''duration:3''tab$''fileName$''newline$'
				endif
			elsif 'including_duration_of_silence_?' = 1
				timeStart = Get start point... number_of_tier i
				timeEnd = Get end point... number_of_tier i
				duration = timeEnd - timeStart
				fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfInterval$''tab$''timeStart:3''tab$''timeEnd:3''tab$''duration:3''tab$''fileName$''newline$'
			endif
		endfor
	endif

	if unit = 2
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 标注'tab$''tab$'平均幅度'tab$'时长'tab$'幅度积'tab$'文件名'newline$'
		endif
		for i from 1 to numberOfIntervals
			labelOfInterval$ = Get label of interval... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfInterval$ != "'lable_of_silence$'"
					timeStart = Get start point... number_of_tier i
					timeEnd = Get end point... number_of_tier i
					duration = timeEnd - timeStart
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					Extract selected sound (preserve times)
					endeditor
					s = 0
					number = Bei 幅度积1
					for m from 1 to number
						value = Bei 幅度积2... 0 'm'
						value = abs(value)
						s = s + value
					endfor
					amplitude = s / number
					amplitudeMean = Bei 幅度积3... amplitude
					fuduji = amplitudeMean * duration
					j = j + 1
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'j'个标注'tab$''labelOfInterval$''tab$''amplitudeMean:0''tab$''duration:3''tab$''fuduji:1''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
				endif
			elsif  'including_duration_of_silence_?' = 1
				timeStart = Get start point... number_of_tier i
				timeEnd = Get end point... number_of_tier i
				duration = timeEnd - timeStart
				select Sound 'fileName$'
				editor Sound 'fileName$'
				Select... timeStart timeEnd
				Extract selected sound (preserve times)
				endeditor
				s = 0
				number = Bei 幅度积1
				for m from 1 to number
					value = Bei 幅度积2... 0 'm'
					value = abs(value)
					s = s + value
				endfor
				amplitude = s / number
				amplitudeMean = Bei 幅度积3... amplitude
				fuduji = amplitudeMean * duration
				fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfInterval$''tab$''amplitudeMean:0''tab$''duration:3''tab$''fuduji:1''tab$''fileName$''newline$'
				select TextGrid 'fileName$'
			endif
		endfor
	endif

	if unit = 3
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 标注'tab$''tab$'起点'tab$'止点'tab$'F1点1'tab$'F1点2'tab$'F1点3'tab$'F1点4'tab$'F1点5'tab$'F1点6'tab$'F1点7'tab$'F1点8'tab$'F1点9'tab$'F1点10'tab$'F2点1'tab$'F2点2'tab$'F2点3'tab$'F2点4'tab$'F2点5'tab$'F2点6'tab$'F2点7'tab$'F2点8'tab$'F2点9'tab$'F2点10'tab$'F3点1'tab$'F3点2'tab$'F3点3'tab$'F3点4'tab$'F3点5'tab$'F3点6'tab$'F3点7'tab$'F3点8'tab$'F3点9'tab$'F3点10'tab$'F4点1'tab$'F4点2'tab$'F4点3'tab$'F4点4'tab$'F4点5'tab$'F4点6'tab$'F4点7'tab$'F4点8'tab$'F4点9'tab$'F4点10'tab$'时长'tab$'文件名'newline$'
		endif
		for i from 1 to numberOfIntervals
			labelOfInterval$ = Get label of interval... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfInterval$ != "'lable_of_silence$'"
					timeStart = Get start point... number_of_tier i
					timeEnd = Get end point... number_of_tier i
					duration = timeEnd - timeStart
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					Zoom... timeStart-2 timeEnd+2
					formant$ = H测量共振峰(10点)
					formant$ = formant$ - "'tab$'"
					time =  timeStart
					timeStep = duration / 9
					for k from 1 to 10
						Move cursor to... time
						f4 = Get formant... 4
						f4$ = "'f4:0'"
						formant$ = formant$ + "'tab$'" + f4$
						time = time + timeStep
					endfor
					endeditor
					j = j + 1
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'j'个标注'tab$''labelOfInterval$''formant$''tab$''duration:3''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
				endif
			elsif  'including_duration_of_silence_?' = 1
					timeStart = Get start point... number_of_tier i
					timeEnd = Get end point... number_of_tier i
					duration = timeEnd - timeStart
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					Zoom... timeStart-2 timeEnd+2
					formant$ = H测量共振峰(10点)
					formant$ = formant$ - "'tab$'"
					time =  timeStart
					timeStep = duration / 9
					for k from 1 to 10
						Move cursor to... time
						f4 = Get formant... 4
						f4$ = "'f4:0'"
						formant$ = formant$ + "'tab$'" + f4$
						time = time + timeStep
					endfor
					endeditor
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfInterval$''formant$''tab$''duration:3''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
			endif
		endfor
		select Sound 'fileName$'
		editor Sound 'fileName$'
		Show all
	endif

	if unit = 4
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 标注'tab$''tab$'基频点1'tab$'基频点2'tab$'基频点3'tab$'基频点4'tab$'基频点5'tab$'基频点6'tab$'基频点7'tab$'基频点8'tab$'基频点9'tab$'时长'tab$'文件名'newline$'
		endif
		for i from 1 to numberOfIntervals
			labelOfInterval$ = Get label of interval... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfInterval$ != "'lable_of_silence$'"
					timeStart = Get start point... number_of_tier i
					timeEnd = Get end point... number_of_tier i
					duration = timeEnd - timeStart
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					duration = timeEnd - timeStart
					Zoom... timeStart-2 timeEnd+2
					pitch$ = H测量基频
					endeditor
					j = j + 1
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'j'个标注'tab$''labelOfInterval$''pitch$''duration:3''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
				endif
			elsif  'including_duration_of_silence_?' = 1
					timeStart = Get start point... number_of_tier i
					timeEnd = Get end point... number_of_tier i
					duration = timeEnd - timeStart
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					duration = timeEnd - timeStart
					Zoom... timeStart-2 timeEnd+2
					pitch$ = H测量基频
					endeditor
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfInterval$''pitch$''duration:3''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
			endif
		endfor
		select Sound 'fileName$'
		editor Sound 'fileName$'
		Show all
	endif

	if unit = 5
		hertz_start = 0
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" consonant'tab$'dot1'tab$'dot2'tab$'dot3'tab$'dot4'tab$'dot5'tab$'dot6'tab$'dot7'tab$'dot8'tab$'dot9'tab$'dot10'tab$'dot11'tab$'dot12'tab$'dot13'tab$'dot14'tab$'dot15'tab$'dot16'tab$'dot17'tab$'dot18'tab$'dot19'tab$'dot20'tab$'duration'tab$'file'tab$'start'tab$'end'newline$'
		endif
		for i from 1 to numberOfIntervals
			labelOfInterval$ = Get label of interval... number_of_tier i
			if labelOfInterval$ != "'lable_of_silence$'"
					timeStart = Get start point... number_of_tier i
					timeEnd = Get end point... number_of_tier i
					duration = timeEnd - timeStart
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					Extract selected sound (preserve times)
					endeditor
					hertzStart = hertz_start
					hertzEnd = Get sampling frequency
					fileName3$ = selected$("Sound")
					file = 0
					if hertzEnd > 20000
						Resample... 20000 50
						hertzEnd = Get sampling frequency
						file = 1
					endif
					if hertzEnd < 20000
						temp = hertzEnd / 2
						appendInfoLine: "录音文件采样率小于20000Hz，频带能量曲线数据在'temp'~10000赫兹以上的会存在问题。"
					endif
					hertzEnd = floor (hertzEnd / 2)
					fileName2$ = selected$("Sound")
					Bei 修改0
					hertzStep = floor((hertzEnd - hertzStart) / 20)	
					energy$ = ""
					for ii from 1 to 20
						binStart = Bei Spectrum2... hertzStart
						binEnd = Bei Spectrum2... hertzStart+hertzStep
						dB = 0
						k = 0
						for jj from binStart to binEnd
							dBTemp = Bei 功率谱分贝值... jj
							dB = dB + dBTemp
							k = k + 1
						endfor
						hertzStart = hertzStart + hertzStep
						dB = dB / k
						energy$ = energy$ + tab$ + "'dB:1'"
					endfor
					j = j + 1
					select TextGrid 'fileName$'
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfInterval$''tab$''energy$''newline$'
					select TextGrid 'fileName$'
			endif
		endfor
		select Sound 'fileName$'
		editor Sound 'fileName$'
		Show all
	endif

elsif isIntervalTier = 0
	if unit = 1
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 标注'tab$''tab$'时点'tab$'文件名'newline$'
		endif
		for i from 1 to numberOfPoints
			labelOfPoint$ = Get label of point... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfPoint$ != "'lable_of_silence$'"
					labelOfPoint$ = Get label of point... number_of_tier i
					time = Get time of point... number_of_tier i
					j = j + 1
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'j'个标注'tab$''labelOfPoint$''tab$''time:3''tab$''fileName$''newline$'
				endif
			elsif  'including_duration_of_silence_?' = 1
				labelOfPoint$ = Get label of point... number_of_tier i
				time = Get time of point... number_of_tier i
				fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfPoint$''tab$''time:3''tab$''fileName$''newline$'
			endif
		endfor
	endif

	if unit = 2
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 标注'tab$''tab$'平均幅度'tab$'时长'tab$'幅度积'tab$'文件名'newline$'
		endif
		for i from 1 to numberOfPoints
			labelOfPoint$ = Get label of point... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfPoint$ != "'lable_of_silence$'"
					time = Get time of point... number_of_tier i
					timeStart = time - 0.0025
					timeEnd = time + 0.0025
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					Extract selected sound (preserve times)
					endeditor
					s = 0
					number = Bei 幅度积1
					for m from 1 to number
						value = Bei 幅度积2... 0 'm'
						value = abs(value)
						s = s + value
					endfor
					amplitude = s / number
					amplitudeMean = Bei 幅度积3... amplitude
					fuduji = amplitudeMean * duration
					j = j + 1
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'j'个标注'tab$''labelOfPoint$''tab$''amplitudeMean:0''tab$''duration:3''tab$''fuduji:1''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
				endif
			elsif  'including_duration_of_silence_?' = 1
					time = Get time of point... number_of_tier i
					timeStart = time - 0.0025
					timeEnd = time + 0.0025
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					Extract selected sound (preserve times)
					endeditor
					s = 0
					number = Bei 幅度积1
					for m from 1 to number
						value = Bei 幅度积2... 0 'm'
						value = abs(value)
						s = s + value
					endfor
					amplitude = s / number
					amplitudeMean = Bei 幅度积3... amplitude
					fuduji = amplitudeMean * duration
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfPoint$''tab$''amplitudeMean:0''tab$''duration:3''tab$''fuduji:1''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
			endif
		endfor
	endif

	if unit = 3
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 标注'tab$''tab$'F1'tab$'F2'tab$'F3'tab$'F4'tab$'时点'tab$'文件名'newline$'
		endif
		for i from 1 to numberOfPoints
			labelOfPoint$ = Get label of point... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfPoint$ != "'lable_of_silence$'"
					time = Get time of point... number_of_tier i
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... time-2 time+2
					Zoom... time-2 time+2
					Move cursor to... time
					f1 = Get first formant
					f2 = Get second formant
					f3 = Get third formant
					f4 = Get formant... 4
					endeditor
					j = j + 1
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'j'个标注'tab$''labelOfPoint$''tab$''f1:0''tab$''f2:0''tab$''f3:0''tab$''f4:0''tab$''time:3''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
				endif
			elsif  'including_duration_of_silence_?' = 1
				time = Get time of point... number_of_tier i
				select Sound 'fileName$'
				editor Sound 'fileName$'
				Select... time-2 time+2
				Zoom... time-2 time+2
				Move cursor to... time
				f1 = Get first formant
				f2 = Get second formant
				f3 = Get third formant
				f4 = Get formant... 4
				endeditor
				fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfPoint$''tab$''f1:0''tab$''f2:0''tab$''f3:0''tab$''f4:0''tab$''time:3''tab$''fileName$''newline$'
				select TextGrid 'fileName$'
			endif
		endfor
	endif

	if unit = 4
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 标注'tab$''tab$'基频'tab$'时点'tab$'文件名'newline$'
		endif
		for i from 1 to numberOfPoints
			labelOfPoint$ = Get label of point... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfPoint$ != "'lable_of_silence$'"
					time = Get time of point... number_of_tier i
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... time-2 time+2
					Zoom... time-2 time+2
					Move cursor to... time
					pitch = Get pitch
					endeditor
					j = j + 1
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'j'个标注'tab$''labelOfPoint$''tab$''pitch:0''tab$''time:3''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
				endif
			elsif  'including_duration_of_silence_?' = 1
					time = Get time of point... number_of_tier i
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... time-2 time+2
					Zoom... time-2 time+2
					Move cursor to... time
					pitch = Get pitch
					endeditor
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfPoint$''tab$''pitch:0''tab$''time:3''tab$''fileName$''newline$'
					select TextGrid 'fileName$'
			endif
		endfor
	endif

	if unit = 5
		hertz_start = 0
		if 'including_title_of_data_?' = 1
			fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" consonant'tab$'dot1'tab$'dot2'tab$'dot3'tab$'dot4'tab$'dot5'tab$'dot6'tab$'dot7'tab$'dot8'tab$'dot9'tab$'dot10'tab$'dot11'tab$'dot12'tab$'dot13'tab$'dot14'tab$'dot15'tab$'dot16'tab$'dot17'tab$'dot18'tab$'dot19'tab$'dot20'tab$'duration'tab$'file'tab$'start'tab$'end'newline$'
		endif
		for i from 1 to numberOfPoints
			labelOfPoint$ = Get label of point... number_of_tier i
			if 'including_duration_of_silence_?' != 1
				if labelOfPoint$ != "'lable_of_silence$'"
					time = Get time of point... number_of_tier i
					timeStart = time - 0.0025
					timeEnd = time + 0.0025
					select Sound 'fileName$'
					editor Sound 'fileName$'
					Select... timeStart timeEnd
					Extract selected sound (preserve times)
					endeditor
					hertzStart = hertz_start
					hertzEnd = Get sampling frequency
					fileName3$ = selected$("Sound")
					file = 0
					if hertzEnd > 20000
						Resample... 20000 50
						hertzEnd = Get sampling frequency
						file = 1
					endif
					if hertzEnd < 20000
						temp = hertzEnd / 2
						appendInfoLine: "录音文件采样率小于20000Hz，频带能量曲线数据在'temp'~10000赫兹以上的会存在问题。"
					endif
					hertzEnd = floor (hertzEnd / 2)
					fileName2$ = selected$("Sound")
					Bei 修改0
					hertzStep = floor((hertzEnd - hertzStart) / 20)	
					energy$ = ""
					for ii from 1 to 20
						binStart = Bei Spectrum2... hertzStart
						binEnd = Bei Spectrum2... hertzStart+hertzStep
						dB = 0
						k = 0
						for jj from binStart to binEnd
							dBTemp = Bei 功率谱分贝值... jj
							dB = dB + dBTemp
							k = k + 1
						endfor
						hertzStart = hertzStart + hertzStep
						dB = dB / k
						energy$ = energy$ + tab$ + "'dB:1'"
					endfor
					j = j + 1
					select TextGrid 'fileName$'
					fileappend "'file_path$'/'name_of_file_to_be_saved$'.txt" 第'i'个标注'tab$''labelOfPoint$''tab$''energy$''newline$'
					select TextGrid 'fileName$'
				endif
			endif
		endfor
	endif
endif

endeditor
select all
minus Strings fileList
Remove
select Strings fileList
endproc
