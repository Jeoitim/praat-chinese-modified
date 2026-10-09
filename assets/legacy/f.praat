if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据V值绘制指定的某个元音的声学位置。
#请读入V值表后再运行本脚本。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.02.24

form set parameters
	comment 请读入V值表后再运行本脚本。
	comment 注意：name_of_picture_to_be_saved处为空则不自动保持图片。
	boolean marks 1
	choice picture_type 1
		button 两图垂直呈现
		button 两图水平呈现
	positive line 1.5
	sentence vowel a
	sentence name_of_picture_to_be_saved 
endform
if index(name_of_picture_to_be_saved$, "/") or index(name_of_picture_to_be_saved$, "\")
    exitScript: "保存名称请只填写文件名，不包含目录。"
endif

temp$ = left$(vowel$, 1)
if temp$ = "/"
pause 您输入的第一个为"/"，不是代码中的"\"，是否继续？
endif
vowel$ = backslashTrigraphsToUnicode$(vowel$)
vowel$ = replace$(vowel$, "（", "(", 0)
vowel$ = replace$(vowel$, "）", ")", 0)
index = index(vowel$,"-")
if index = 3
	right$ = right$(vowel$, 1)
	vowel$ = vowel$ - right$(vowel$, 2)
	if right$ = "1"
		vowel$ = left$(vowel$, 1) + "(" + mid$(vowel$, 2, 1) + ")"
	elsif right$ = "2"
		vowel$ = "(" + left$(vowel$, 1) + ")" + mid$(vowel$, 2, 1)
	endif
endif
if index = 4
	right$ = right$(vowel$, 1)
	vowel$ = vowel$ - right$(vowel$, 2)
	if right$ = "1"
		vowel$ = left$(vowel$, 1) + "(" + mid$(vowel$, 2, 2) + ")"
	elsif right$ = "2"
		vowel$ = "(" + left$(vowel$, 1) + ")" + mid$(vowel$, 2, 1) + "(" + mid$(vowel$, 3, 1) + ")"
	elsif right$ = "3"
		vowel$ = "(" + mid$(vowel$, 1, 2)  + ")" + mid$(vowel$, 3, 1)
	endif
endif

columnLabel$ = Get column label... 3
maximum = Get maximum... 'columnLabel$'
if maximum > 100
exit 请选择正确的V值表。
endif
numberOfRows = Search column... vowel 'vowel$'
if numberOfRows = 0
exit 表中不存在指定的元音，请重新输入。
endif
valuef1 = Get value... numberOfRows F1
valuef2 = Get value... numberOfRows F2
Select outer viewport... 0 6 0 4
Draw inner box
Axes... 100 0 100 0
Marks left every... 1 20 yes yes no
Marks bottom every... 1 20 yes yes no
if valuef1 >= 98 or valuef1 <= 2 or valuef2 >= 98 or valuef2 <= 2
White
Line width... 16
Draw line... valuef2+line valuef1+line valuef2+line valuef1-line
Draw line... valuef2+line valuef1+line valuef2-line valuef1+line
Draw line... valuef2+line valuef1+line valuef2-line valuef1-line
Draw line... valuef2+line valuef1-line valuef2-line valuef1+line
Draw line... valuef2+line valuef1-line valuef2-line valuef1-line
Draw line... valuef2-line valuef1+line valuef2-line valuef1-line
Line width... 1
endif
Black
Text special... valuef2 centre valuef1 half Times 18 0 'vowel$'
Red
if marks = 1
Draw line... 100 20 0 30
Draw line... 100 80 0 70
Draw line... 80 0 60 100
Draw line... 20 0 40 100
endif
Black
Font size... 10
Text left... yes F1(V value)
Text bottom... yes F2(V value)

#画F1~F3-F2
Black
if picture_type = 1
	Select outer viewport... 0 6 4 8
elsif picture_type = 2
	Select outer viewport... 6 12 0 4
endif
Draw inner box
Axes... 0 100 100 0
Marks left every... 1 20 yes yes no
Marks bottom every... 1 20 yes yes no
valuef1 = Get value... numberOfRows F1
valuef32 = Get value... numberOfRows F3-F2
if valuef1 >= 98 or valuef1 <= 2 or valuef32 >= 98 or valuef32 <= 2
White
Line width... 16
Draw line... valuef32+line valuef1+line valuef32+line valuef1-line
Draw line... valuef32+line valuef1+line valuef32-line valuef1+line
Draw line... valuef32+line valuef1+line valuef32-line valuef1-line
Draw line... valuef32+line valuef1-line valuef32-line valuef1+line
Draw line... valuef32+line valuef1-line valuef32-line valuef1-line
Draw line... valuef32-line valuef1+line valuef32-line valuef1-line
Line width... 1
endif
Black
Text special... valuef32 Centre valuef1 Half Times 18 0 'vowel$'
Red
if marks = 1
Draw line... 100 20 0 30
Draw line... 100 80 0 70
Draw line... 80 0 60 100
Draw line... 20 0 40 100
endif
Black
Font size... 10
Text left... yes F1(V value)
Text bottom... yes F3-F2(V value)
Select outer viewport... 0 6 0 4
if name_of_picture_to_be_saved$ != ""
	if windows
	    Save as 600-dpi PNG file: "'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'"
	else
	    Save as PDF file: "'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'"
	endif
endif