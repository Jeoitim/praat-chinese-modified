legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是转换音视频文件格式。
#2021.07.24
# jeoitim：跨平台资源与外部工具适配；算法来源署名保留。
form 转换音视频文件格式
    sentence file_path .
    sentence extension_name_of_source_files m4a
    sentence extension_name_of_target_files wav
endform
if file_path$ = "."
    file_path$ = legacyDataDirectory$
endif
Create Strings as file list: "fileList", file_path$ + "/*." + extension_name_of_source_files$
count = Get number of strings
for i from 1 to count
    source$ = Get string: i
    target$ = left$(source$,length(source$)-length(extension_name_of_source_files$)) + extension_name_of_target_files$
    runSubprocess: ffmpegExecutable$, "-nostdin", "-n", "-i", file_path$ + "/" + source$, file_path$ + "/" + target$
endfor
Remove
