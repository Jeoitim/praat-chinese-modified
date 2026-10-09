legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是统计分词后的词频。
#2021.03.10
# jeoitim：跨平台资源与外部工具适配；算法来源署名保留。
form 分词与词频统计
    choice order 1
        button 按词频排列
        button 按词性排列
    boolean word_cloud 0
    comment 自动分词需要 Python 3 与 jieba；词云另需 wordcloud、Pillow 和支持中文的字体。
    sentence chinese_font
endform
input$ = chooseReadFile$: "请选择需要分词的文本"
if input$ = ""
    exitScript: "已取消。"
endif
output$ = chooseWriteFile$: "保存词频表", "词频.tsv"
if output$ <> ""
    runSubprocess: pythonExecutable$, applicationDirectory$ + "/assets/platform/word_tools.py", input$, output$, string$(order), string$(word_cloud), chinese_font$
    Read Table from tab-separated file: output$
endif
