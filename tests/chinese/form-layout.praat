# UI regression fixture: descriptions followed by controls in both form types.
# jeoitim; run interactively and inspect initial, resized and scrolled windows.
form 参数窗口布局验证
    comment 注意 软件分别测量所选段平均幅度、时长、幅度积
    boolean print_title_of_data 0
    comment 以下选择绘图标度：
    choice scale 1
        button 赫兹
        button 半音
    comment 这条说明以英文句点结束.
    sentence unit 测试标注
endform
beginPause: "暂停窗口布局验证"
    comment: "注意 软件分别测量所选段平均幅度、时长、幅度积"
    boolean: "print_title_of_data", 0
    comment: "以下选择绘图标度："
    choice: "scale", 1
        option: "赫兹"
        option: "半音"
    comment: "这条说明以英文句点结束."
    sentence: "unit", "测试标注"
clicked = endPause: "继续", 1
appendInfoLine: "PASS: both description/control layouts inspected"
