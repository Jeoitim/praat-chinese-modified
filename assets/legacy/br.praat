legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是绘制根据能量分布模式表某个辅音的谱重心和离散程度。
#请读入能量分布模式表.txt后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.02.24

form set parameters
	comment 请读入能量分布模式表后再运行本脚本。
	comment 注意：name_of_picture_to_be_saved处为空则不自动保持图片。
	boolean marks 1
	positive line 1.5
	sentence consonant s
	sentence name_of_picture_to_be_saved 
endform

endeditor
fileName$ = selected$("Table")
columnLabel$ = Get column label... 3
maximum = Get maximum... 'columnLabel$'
if maximum != 100
	exit 请选择正确的能量分布模式表。
endif
numberOfRows = Search column... consonant 'consonant$'
if numberOfRows = 0
	exit 表中不存在指定的辅音，请重新输入。
endif
valueGravity = Get value... numberOfRows Gravity
valueDispersion = Get value... numberOfRows Dispersion
Select outer viewport... 0 6 0 4
Draw inner box
Axes... 100 0 100 0
Marks left every... 1 20 yes yes no
Marks bottom every... 1 20 yes yes no
if valueGravity >= 98 or valueGravity <= 2 or valueDispersion >= 98 or valueDispersion <= 2
	White
	Line width... 16
	Draw line... valueDispersion+line valueGravity+line valueDispersion+line valueGravity-line
	Draw line... valueDispersion+line valueGravity+line valueDispersion-line valueGravity+line
	Draw line... valueDispersion+line valueGravity+line valueDispersion-line valueGravity-line
	Draw line... valueDispersion+line valueGravity-line valueDispersion-line valueGravity+line
	Draw line... valueDispersion+line valueGravity-line valueDispersion-line valueGravity-line
	Draw line... valueDispersion-line valueGravity+line valueDispersion-line valueGravity-line
	Line width... 1
endif
Black
Text special... valueDispersion centre valueGravity half Times 18 0 'consonant$'
Red
if marks = 1
	Marks left... 6 no yes yes
endif
Black
Font size... 10
Text left... yes Gravity
Text bottom... yes Dispersion
if name_of_picture_to_be_saved$ != ""
	Save as Windows metafile: "'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf"
endif
Select outer viewport: 0, 6, 0, 4
#END