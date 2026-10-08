legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是打开常见的几个程序（记事本、word、excel、powerpoint、dos、ie、edge）。
#2021.08.13
# jeoitim：跨平台资源与外部工具适配；算法来源署名保留。
form 打开常用程序
    choice application 1
        button 文本编辑器
        button 文字处理
        button 电子表格
        button 演示文稿
        button 终端
        button 浏览器
endform
runSubprocess: pythonExecutable$, applicationDirectory$ + "/assets/platform/platform_tools.py", "application", string$(application)
