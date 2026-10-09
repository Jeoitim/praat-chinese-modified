# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
# 原语调画图功能：贝先明；当前 API、64 Hz 标度和便携输出适配：jeoitim。
form 语调画图
    positive pitch_floor 64
    positive pitch_ceiling 362
    real time_start 0
    real time_end 0
    choice scale 1
        button Semitones
        button Hertz
    boolean erase_picture_already_existed 1
    boolean draw_with_textGrid 0
    sentence name_of_picture_to_be_saved 语调图
endform
legacyDataDirectory$ = dataDirectory$
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif
if numberOfSelected("Sound") <> 1
    exitScript: "请在对象窗口选中一个声音对象。需要标注时，同时选中一个 TextGrid。"
endif
soundID = selected("Sound")
if draw_with_textGrid
    if numberOfSelected("TextGrid") <> 1
        exitScript: "绘制标注时，请同时选中一个 TextGrid 对象。"
    endif
    gridID = selected("TextGrid")
endif
selectObject: soundID
duration = Get total duration
if time_end = 0
    time_end = duration
endif
if time_start < 0 or time_end <= time_start or time_end > duration
    exitScript: "绘图时间范围超出声音范围。"
endif
if pitch_ceiling <= pitch_floor
    exitScript: "基频上限必须大于下限。"
endif
To Pitch: 0, pitch_floor, pitch_ceiling + 120
pitchID = selected("Pitch")
tablePath$ = legacyDataDirectory$ + "/" + name_of_picture_to_be_saved$ + ".tsv"
if fileReadable(tablePath$)
    exitScript: "结果文件已经存在，请更换保存名称：", tablePath$
endif
writeFileLine: tablePath$, "time", tab$, "hertz", tab$, "semitones_re_64_Hz"
frames = Get number of frames
for frame from 1 to frames
    time = Get time from frame number: frame
    if time >= time_start and time <= time_end
        frequency = Get value at time: time, "Hertz", "Linear"
        semitones = 12 * log2(frequency / 64)
        appendFileLine: tablePath$, fixed$(time, 6), tab$, string$(frequency), tab$, string$(semitones)
    endif
endfor
if erase_picture_already_existed
    Erase all
endif
if draw_with_textGrid
    Select outer viewport: 0, 6, 1.1, 4
else
    Select outer viewport: 0, 6, 0, 4
endif
Black
Line width: 1.5
if scale = 1
    lower100 = 12 * log2(pitch_floor / 100)
    upper100 = 12 * log2(pitch_ceiling / 100)
    Draw semitones (re 100 Hz): time_start, time_end, lower100, upper100, "no"
    # The reference offset changes labels, not the plotted geometry.
    Axes: time_start, time_end, 12*log2(pitch_floor/64), 12*log2(pitch_ceiling/64)
    Text left: "yes", "基频（半音，参考 64 Hz）"
else
    Draw: time_start, time_end, pitch_floor, pitch_ceiling, "no"
    Text left: "yes", "基频（Hz）"
endif
Line width: 1
Draw inner box
Marks bottom: 11, "yes", "yes", "no"
Marks left: 6, "yes", "yes", "yes"
Text bottom: "yes", "时间（秒）"
if draw_with_textGrid
    selectObject: gridID
    Select outer viewport: 0, 6, 0, 1.1
    Draw: time_start, time_end, "yes", "yes", "yes"
endif
Select outer viewport: 0, 6, 0, 4
if windows
    picturePath$ = legacyDataDirectory$ + "/" + name_of_picture_to_be_saved$ + ".png"
    if fileReadable(picturePath$)
        exitScript: "图片已经存在，请更换保存名称：", picturePath$
    endif
    Save as 600-dpi PNG file: picturePath$
else
    picturePath$ = legacyDataDirectory$ + "/" + name_of_picture_to_be_saved$ + ".pdf"
    if fileReadable(picturePath$)
        exitScript: "图片已经存在，请更换保存名称：", picturePath$
    endif
    Save as PDF file: picturePath$
endif
selectObject: pitchID
Remove
selectObject: soundID
appendInfoLine: "已保存语调图和数据：", picturePath$, "；", tablePath$
