legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是绘制各种声学图。
#请在声音编辑器中运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.04.25

form set parameters
	comment 注意： 每次最多选四种图进行绘制。
	comment 注意： 若有标注文件，须与声音文件同名并读入主编辑器。
	positive formantMax 5000
	boolean 波形图 1
	boolean 频谱图 0
	boolean 语谱图 1
	boolean 共振峰曲线图 1
	boolean 音强曲线图 1
	boolean 基频曲线图 0
	boolean 标注内容图 0
	sentence name_of_picture_to_be_saved 声学图
endform

editorInfo$ = Editor info
fileName0$ = extractWord$(editorInfo$,"Data name:")
timeStart = Get start of selection
timeEnd = Get end of selection
duration = Get selection length
if duration = 0
	exit 请用鼠标选择一段波形图或宽带语图
endif
pitchMin = Get minimum pitch
Extract selected sound (time from 0)
endeditor
Edit
fileName$ = selected$("Sound")
Erase all
i = 0
Font size... 12

if 波形图 = 1
	Black
	Select outer viewport... 0 6 0+i*3 3+i*3
	Draw... 0 duration 0 0 yes Curve
	Marks bottom... 11 no yes no
	i = i + 1
	Select outer viewport... 0 6 0 3+i*3
endif

if 频谱图 = 1
	Black
	editor Sound 'fileName$'
	Select... 0 duration
	View spectral slice
	endeditor
	Select outer viewport... 0 6 0+i*3 3+i*3
	Draw... 0 10000 0 0 yes
	Marks bottom... 11 no yes no
	Remove
	i = i + 1
	Select outer viewport... 0 6 0 3+i*3
endif

if 语谱图 = 1
	Black
	select Sound 'fileName$'
	To Spectrogram... 0.005 5000 0.002 20 Gaussian
	Select outer viewport... 0 6 0+i*3 3+i*3
	Paint... 0 duration 0 5000 100 yes 50 6 0 yes
	Marks left... 6 yes yes no
	Marks bottom... 11 no yes no
	Remove
	i = i + 1
	Select outer viewport... 0 6 0 3+i*3
endif

if 共振峰曲线图 = 1
	Red
	select Sound 'fileName$'
	To Formant (burg)... 0 5 formantMax 0.025 50
	Select outer viewport... 0 6 0+i*3 3+i*3
	Speckle... 0 duration 5000 30 yes
	Marks bottom... 11 no yes no
	Remove
	i = i + 1
	Black
	Select outer viewport... 0 6 0 3+i*3
endif

if 音强曲线图 = 1
	Green
	select Sound 'fileName$'
	To Intensity... 'pitchMin' 0 yes
	Select outer viewport... 0 6 0+i*3 3+i*3
	Line width: 2.0
	Draw... 0 duration 30 110 no
	Line width: 1.0
	Draw... 0 duration 30 110 yes
	Marks bottom... 11 no yes no
	Marks left... 5 yes yes no
	Remove
	Select outer viewport... 0 6 0 3+i*3
	i = i + 1
	if i > 4
		exit 所选大于4种图形，只画前面4种!
	endif
endif

if 基频曲线图 = 1
	Blue
	select Sound 'fileName$'
	To Pitch... 0 75 600
	Select outer viewport... 0 6 0+i*3 3+i*3
	Line width: 2.0
	Draw... 0 duration 0 600 no
	Line width: 1.0
	Draw... 0 duration 0 600 yes
	Marks bottom... 11 no yes no
	Marks left... 7 yes yes no
	Remove
	Select outer viewport... 0 6 0 3+i*3
	i = i + 1
	if i > 4
		exit 所选大于4种图形，只画前面4种!
	endif
endif
select Sound 'fileName$'
Remove

if 标注内容图 = 1
	Black
	select TextGrid 'fileName0$'
	Select outer viewport... 0 6 0+i*3 3+i*3
	Draw... 'timeStart' 'timeEnd' yes yes yes
	Marks bottom... 11 no yes no
	Select outer viewport... 0 6 0 3+i*3
	i = i + 1
	if i > 4
		exit 所选大于4种图形，只画前面4种!
	endif
endif

Font size... 10
Black
i=fileReadable("'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf")
if i = 1
	pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
Save as Windows metafile... 'legacyDataDirectory$'\'name_of_picture_to_be_saved$'.emf
select Sound 'fileName0$'
editor Sound 'fileName0$'
Select... timeStart timeEnd