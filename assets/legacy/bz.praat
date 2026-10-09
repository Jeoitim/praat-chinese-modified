# 补充实现：jeoitim（Praat 修改版）。
# 原安装包缺少 bz.cab；此补充脚本根据用户提供的普通话元音数据绘制 V 值图。
# 需要选中包含 vowel、F1、F2 列的 V 值 Table；不会伪造标准参考数据。
form 绘制普通话元音V值图
    comment 请选择包含 vowel、F1、F2 列的V值表。数值由您的参考数据决定。
endform
count = Get number of rows
Erase all
Select outer viewport: 0, 6, 0, 4
Axes: 100, 0, 100, 0
Draw inner box
Marks left every: 1, 20, "yes", "yes", "no"
Marks bottom every: 1, 20, "yes", "yes", "no"
Text left: "yes", "F1 (V value)"
Text bottom: "yes", "F2 (V value)"
for row from 1 to count
    vowel$ = Get value: row, "vowel"
    f1 = Get value: row, "F1"
    f2 = Get value: row, "F2"
    Text special: f2, "centre", f1, "half", "Times", 18, 0, vowel$
endfor
