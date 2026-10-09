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
#本脚本的功能是多人V值表画椭圆图。图片保存在软件所在文件夹的data文件夹。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.06.10

form set parameters
	comment 注意 请先读入多个（至少3个）V值表再运行本菜单
	choice picture_type 1
		button 两图垂直呈现
		button 两图水平呈现
	positive confidence 0.955
	sentence name_of_picture_to_be_saved 多人V值椭圆图
	boolean scatter_plot 0
endform
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif

endeditor
select all
Append
Down to TableOfReal... vowel
To Discriminant
Select outer viewport... 0 6 0 4
if scatter_plot = 1
	select TableOfReal appended
	Draw scatter plot: 2, 1, 0, 0, 100, 0, 100, 0, 12, "yes", "", "no"
	select Discriminant appended
endif
Draw confidence ellipses... 'confidence' no 2 1 100 0 100 0 18 yes
if picture_type = 1
	Select outer viewport... 0 6 4 8
elsif picture_type = 2
	Select outer viewport... 6 12 0 4
endif
if scatter_plot = 1
	select TableOfReal appended
	Draw scatter plot: 3, 1, 0, 0, 100, 0, 100, 0, 12, "yes", "", "no"
	select Discriminant appended
endif
Draw confidence ellipses... 'confidence' no 3 1 100 0 100 0 18 yes

Select outer viewport... 0 6 0 4
createDirectory: legacyDataDirectory$
i=fileReadable("'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'")
if i = 1
	pause 'name_of_picture_to_be_saved$'已经存在，请将其先移走，否则会被覆盖！
endif
if windows
    Save as 600-dpi PNG file... 'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'
else
    Save as PDF file... 'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'
endif
select all
Remove
