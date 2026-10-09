# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能单独画某塞擦音。
#请读入V值表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.09.30

form set parameters
	comment 请读入时长与能量分布值表后再运行本脚本。
	comment 注意：name_of_picture_to_be_saved处为空则不自动保持图片。
	boolean marks 1
	positive line 1.5
	sentence affricate ts
	sentence name_of_picture_to_be_saved 
endform
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif

endeditor
fileName$ = selected$("Table")
columnLabel$ = Get column label... 7
maximum = Get maximum... 'columnLabel$'
if maximum != 100
exit 请选择正确的时长与能量分布值表。
endif
affricate$ = backslashTrigraphsToUnicode$(affricate$)
numberOfRows = Search column... affricate 'affricate$'
if numberOfRows = 0
exit 表中不存在指定的塞擦音，请重新输入。
endif
valueFrictionIndex = Get value... numberOfRows FrictionIndex
valueDurationIndex = Get value... numberOfRows DurationIndex
Select outer viewport... 0 6 0 4
Draw inner box
Axes... 0 100 0 100
Marks left every... 1 20 yes yes no
Marks bottom every... 1 20 yes yes no
if valueFrictionIndex >= 98 or valueFrictionIndex <= 2 or valueDurationIndex >= 98 or valueDurationIndex <= 2
White
Line width... 16
Draw line... valueDurationIndex+line valueFrictionIndex+line valueDurationIndex+line valueFrictionIndex-line
Draw line... valueDurationIndex+line valueFrictionIndex+line valueDurationIndex-line valueFrictionIndex+line
Draw line... valueDurationIndex+line valueFrictionIndex+line valueDurationIndex-line valueFrictionIndex-line
Draw line... valueDurationIndex+line valueFrictionIndex-line valueDurationIndex-line valueFrictionIndex+line
Draw line... valueDurationIndex+line valueFrictionIndex-line valueDurationIndex-line valueFrictionIndex-line
Draw line... valueDurationIndex-line valueFrictionIndex+line valueDurationIndex-line valueFrictionIndex-line
Line width... 1
endif
Black
Text special... valueDurationIndex centre valueFrictionIndex half Times 18 0 'affricate$'
Red
Black
Font size... 10
Text left... yes FrictionIndex
Text bottom... yes DurationIndex
if name_of_picture_to_be_saved$ != ""
	if windows
	    Save as 600-dpi PNG file: "'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'"
	else
	    Save as PDF file: "'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'"
	endif
endif
Select outer viewport: 0, 6, 0, 4
#END