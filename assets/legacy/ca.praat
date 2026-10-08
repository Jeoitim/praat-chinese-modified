legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是转换音视频文件格式。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.07.24


form set parameters
	comment 文件路径和文件名请勿包含空格！
	sentence file_path D:\praat汉化修改版\sound
	sentence extension_name_of_source_files m4a
	sentence extension_name_of_target_files wav
endform

if file_path$ = ""
	exit 声音文件所在目录不能为空!
endif
file_path$ = file_path$ + "\"
Create Strings as file list... fileList 'file_path$'\*.'extension_name_of_source_files$'
numberOfStrings = Get number of strings
for times from 1 to numberOfStrings
	select Strings fileList
	sourceFileName$ = Get string... times
	targetFileName$ = sourceFileName$ - extension_name_of_source_files$ + extension_name_of_target_files$
	j = fileReadable("'file_path$'\'targetFileName$'")
	if j = 1
		exit 'targetFileName$'已经存在，请将其先移走或者删除！
	endif
	runSystem: applicationDirectory$, "\ffmpeg.exe -i ", file_path$, sourceFileName$, " ", file_path$, targetFileName$
endfor
select Strings fileList
Remove
