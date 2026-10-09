legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是播放视频。
#2019.05.21
# jeoitim：跨平台资源与外部工具适配；算法来源署名保留。
form 播放视频
    positive x 1600
    positive y 900
endform
file$ = chooseReadFile$: "请选择需要播放的视频文件"
if file$ <> ""
    runSubprocess: ffplayExecutable$, "-showmode", "0", "-x", string$(x), "-y", string$(y), "-exitonkeydown", file$
endif
