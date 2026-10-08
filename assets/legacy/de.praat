legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是调整录音音量。
#2022.11.06
# jeoitim：跨平台资源与外部工具适配；算法来源署名保留。
form 调整系统音量
    comment 此操作调整系统默认设备的音量。
    choice action 1
        button 打开系统音量设置
        button 静音
        button 最大音量
endform
runSubprocess: pythonExecutable$, applicationDirectory$ + "/assets/platform/platform_tools.py", "volume", "recording", string$(action), applicationDirectory$
