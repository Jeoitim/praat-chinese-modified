# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
# 视频处理脚本：保留贝先明原功能；直接引用输入文件，支持空格与中文路径。
form 视频文件夹
    sentence directory .
endform
if directory$ = "."
    directory$ = dataDirectory$
endif
ffmpeg$ = ffmpegExecutable$
Create Strings as file list: "fileList", directory$ + "/*.*"
count = Get number of strings
for i from 1 to count
    name$ = Get string: i
    dot = rindex(name$, ".")
    extension$ = lowerCase$(right$(name$,length(name$)-dot))
    if index(" mp4 mkv mov avi flv webm wmv mpg mpeg m4v 3gp "," " + extension$ + " ") <> 0
        input$ = directory$ + "/" + name$
        stem$ = left$(name$,dot-1)
        output$ = dataDirectory$ + "/new" + stem$ + ".mp4"
        runSubprocess: ffmpeg$, "-nostdin", "-n", "-i", input$, "-an", "-c:v", "copy", output$
    endif
endfor
Remove
