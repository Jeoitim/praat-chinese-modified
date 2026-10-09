# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是截取视频。
#2019.05.21
# jeoitim：跨平台资源与外部工具适配；算法来源署名保留。
form 截取视频
    sentence timeStart 00:00:01
    sentence timeEnd 00:00:03
endform
input$ = chooseReadFile$: "请选择视频"
if input$ = ""
    exitScript: "已取消。"
endif
output$ = chooseWriteFile$: "保存截取的视频", "截取.mp4"
if output$ <> ""
    runSubprocess: ffmpegExecutable$, "-nostdin", "-n", "-i", input$, "-ss", timeStart$, "-to", timeEnd$, output$
endif
