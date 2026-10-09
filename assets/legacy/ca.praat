# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
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
    runSubprocess: ffmpegExecutable$, "-nostdin", "-n", "-i", file_path$ + "/" + source$, legacyDataDirectory$ + "/" + target$
endfor
Remove
