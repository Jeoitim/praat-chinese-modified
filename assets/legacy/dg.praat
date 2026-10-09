legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是录制屏幕、声卡和麦克风。
#2022.11.12
# jeoitim：跨平台资源与外部工具适配；算法来源署名保留。
form 录制视频
    comment 按设定时长录制；设备名称与系统权限见跨平台指南。
    comment Windows：填写 DirectShow 名称；macOS：填写 AVFoundation 索引；Linux：填写 PulseAudio 设备及显示地址或摄像头路径。
    positive duration 10
    sentence video_device auto
    sentence microphone default
    sentence system_audio default
    sentence watermark bei
    sentence fontcolor red
    positive fontsize 50
    sentence filename myvideo.mp4
endform
output$ = chooseWriteFile$: "保存录像", filename$
if output$ <> ""
    runSubprocess: pythonExecutable$, applicationDirectory$ + "/assets/platform/platform_tools.py", "capture", "screen-mix", ffmpegExecutable$, output$, string$(duration), video_device$, microphone$, system_audio$, watermark$, fontcolor$, string$(fontsize)
endif
