legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是打开指定的文件夹。
#2020.08.30
# jeoitim：跨平台资源与外部工具适配；算法来源署名保留。
form 打开文件夹
    choice open_path 2
        button 程序资源目录
        button 分析数据目录
        button 录音目录
        button 偏好设置目录
        button 指定路径或网址
    sentence other_path .
endform
if open_path = 1
    target$ = applicationDirectory$
elsif open_path = 2
    target$ = legacyDataDirectory$
elsif open_path = 3
    target$ = legacyDataDirectory$ + "/sound"
    createDirectory: target$
elsif open_path = 4
    target$ = preferencesDirectory$
else
    target$ = other_path$
endif
Modified open resource: target$
