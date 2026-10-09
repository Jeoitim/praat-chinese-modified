# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据vowel.txt文件自动标注声音文件的元音信息。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2022.10.28

form set parameters
	sentence sound_type wav
	boolean write_back_to_input_directory 1
endform

pathFileName$ = chooseReadFile$: "请选择vowel文件"
if pathFileName$ = ""
    exitScript: "已取消。"
endif
# jeoitim：保留原脚本的空格转制表符并写回步骤；改写前在输入目录备份原文件。
Modified format analysis text: pathFileName$
Modified read analysis table: pathFileName$, ""

fileName$ = selected$("Table")
numberOfColumns = Get number of columns
for i from 1 to numberOfColumns
	column_label_temp$ = Get column label... i
	if i = 1
		Set column label (label)... 'column_label_temp$' vowel
	elsif i > 1
		j = i - 1
		Set column label (label)... 'column_label_temp$' dot'j'
	endif
endfor
fileName$ = selected$("Table")
tableID = selected("Table")
inputFolder$ = left$(pathFileName$, rindex_regex(pathFileName$, "[/\\]"))
numberOfRows = Get number of rows
for i from 1 to numberOfRows
	label$ = Get value... i vowel
	if label$ = "vowel"
		Remove row... i
		numberOfRows = numberOfRows -1
	endif
endfor

numberOfRows = Get number of rows
for i from 1 to numberOfRows
	selectObject: tableID
	vowel$ = Get value... i vowel
	soundFile$ = Get value... i dot4
	time = Get value... i dot5
	if index(soundFile$, "/") or index(soundFile$, "\")
	    exitScript: "数据中的声音文件名不能包含目录。"
	endif
	soundPathFileName$ = inputFolder$ + soundFile$ + "." + sound_type$
	soundFileReadable = fileReadable(soundPathFileName$)
	if soundFileReadable != 1
		appendInfoLine: "'soundFile$'不存在"
	elsif soundFileReadable = 1
		Read from file: soundPathFileName$
		textGridPathFileName$ = inputFolder$ + soundFile$ + ".TextGrid"
		outputGrid$ = legacyDataDirectory$ + "/" + soundFile$ + ".TextGrid"
		if write_back_to_input_directory
		    outputGrid$ = textGridPathFileName$
		endif
		if fileReadable(outputGrid$)
		    textGridPathFileName$ = outputGrid$
		endif
		textGridFileReadable = fileReadable(textGridPathFileName$)
		if textGridFileReadable != 1
			To TextGrid: "vowel", "vowel"
		elsif textGridFileReadable = 1
			Read from file: textGridPathFileName$
		endif
			nocheck Insert point: 1, time, vowel$
			Save as text file: outputGrid$
			select TextGrid 'soundFile$'
			Remove
		select Sound 'soundFile$'
		Remove
	endif
endfor
appendInfoLine: "标注完成！"