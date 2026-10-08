if windows
    legacyPictureExtension$ = "png"
else
    legacyPictureExtension$ = "pdf"
endif
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对单独画某句起伏度。
#请读入起伏度值表后再运行本脚本。注意，运行本脚本将移去praat列表中的所有文件，如列表中有文件，请先行保存。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.06.09

form set parameters
	comment 注意：请读入起伏度值表后再运行本菜单。
	comment 注意：主编辑器请不要读入其他文件。
	comment 注意：name_of_picture_to_be_saved处为空则不自动保持图片。
	choice color 1
		button random
		button Red
		button Blue
		button Green
		button Black
	boolean rectangle 1
	sentence numberOfSentence 1
	natural phraseStart 1
	natural phraseEnd 3
	sentence name_of_picture_to_be_saved 
endform

endeditor
fileName$ = selected$("Table")
numberOfColumns = Get number of columns
if numberOfColumns < 4
	exit 请选择正确的起伏度值表。
endif
columnLabelTemp$ = Get column label... 4
if columnLabelTemp$ != "dot1"
	exit 请选择正确的起伏度值表。
endif
maxTemp = Get maximum... dot1
if maxTemp > 100
	exit 请选择正确的起伏度值表。
endif

numberOfSyllable = Get maximum... numberOfSyllable
if rectangle != 1
	Erase all
endif
Font size... 14
Draw inner box
Axes... 1 9*numberOfSyllable+numberOfSyllable-1 0 100
Marks bottom every... 1 1 no yes no
Marks bottom every... 1 10 yes yes no
Marks left every... 1 10 yes yes no
Text bottom... yes Time (normalized)
Text left... yes Pitch (Q value)
numberOfRows = Get number of rows
numberOfColumns = 13

for i from 1 to numberOfRows
	numberOfSentenceOrPhrase$ = Get value... i numberOfSentenceOrPhrase
	if numberOfSentence$ = numberOfSentenceOrPhrase$
		for j from 4 to numberOfColumns-1
			toneLabel$ = Get column label... 3
			toneName$ = Get value... i 'toneLabel$'
			dotLabel$ = Get column label... j
			numberOfSyllableTemp = Get value... i numberOfSyllable
			tZhi = Get value... i 'dotLabel$'
			zz = Get value... i numberOfSentenceOrPhrase
			if color = 1
				if zz mod 2 = 0 and zz mod 4 != 0
					Red
					symbol$ = "■"
				elsif zz mod 3 = 0
					Green
					symbol$ = "◆" 
				elsif zz mod 4 = 0
					Blue
					symbol$ = "●"
				elsif zz mod 5 = 0
					Cyan
					symbol$ = "▲" 
				else
					Black
					symbol$ = "▼" 
				endif
			elsif color = 2
				Red
				symbol$ = "■"
			elsif color = 3	
				Blue
				symbol$ = "◆" 
			elsif color = 4
				Green
				symbol$ = "▲" 
			elsif color = 5
				Black
				symbol$ = "▼" 
			endif
		
			Text... j-3+9*(numberOfSyllableTemp-1)+(numberOfSyllableTemp-1) Centre tZhi Half 'symbol$'

			if j-3+9*(numberOfSyllableTemp-1)+(numberOfSyllableTemp-1) != 1+(9+1)*(numberOfSyllableTemp-1)
				labelBeforeOneDot$ = Get column label... j-1
				tZhiBeforeOneDot = Get value... i 'labelBeforeOneDot$'
				Black
				Draw line... (j-3)+9*(numberOfSyllableTemp-1)+(numberOfSyllableTemp-1)-1 tZhiBeforeOneDot (j-3)+9*(numberOfSyllableTemp-1)+(numberOfSyllableTemp-1) tZhi
			endif
		endfor
	endif
endfor

if phraseStart > phraseEnd
	exit phraseStart、phraseEnd填写有误。
endif
if rectangle = 1
	Blue
	Sort rows... numberOfSyllable numberOfSentenceOrPhrase
	Extract rows where column (text)... numberOfSentenceOrPhrase "is equal to" 'numberOfSentence$'
	Rename... 0
	for i from phraseStart to phraseEnd
		select Table 0
			Extract rows where column (text)... numberOfSyllable "is equal to" 'i'
			Rename... 'i'
	endfor
	select all
	minus Table 'fileName$'
	minus Table 0
	Append
	for j from 1 to 9
		maxNew = Get maximum... dot'j'
		if j = 1
			max0 = maxNew
		endif
		if max0 < maxNew
			max0 = maxNew
		endif
		minNew = Get minimum... dot'j'
		if j = 1
			min0 = minNew
		endif
		if min0 > minNew
			min0 = minNew
		endif
	endfor
	printline 'phraseStart'~'phraseEnd'方框起伏度最大值为：'max0:0'
	printline 'phraseStart'~'phraseEnd'方框起伏度最小值为：'min0:0'
	Draw line... (phraseStart-1)*10+1 max0 (phraseEnd-1)*10+9 max0
	Draw line... (phraseStart-1)*10+1 min0 (phraseEnd-1)*10+9 min0
	Draw line... (phraseStart-1)*10+1 min0 (phraseStart-1)*10+1 max0
	Draw line... (phraseEnd-1)*10+9 min0 (phraseEnd-1)*10+9 max0

	valueDot = (phraseStart + (phraseEnd - phraseStart + 1)/2 - 1) * 10
	Text... valueDot Centre max0+5 Half 'max0:0'
	Text... valueDot Centre min0-5 Half 'min0:0'
endif
if name_of_picture_to_be_saved$ != ""
	if windows
	    Save as 600-dpi PNG file: "'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'"
	else
	    Save as PDF file: "'legacyDataDirectory$'/'name_of_picture_to_be_saved$'.'legacyPictureExtension$'"
	endif
endif

select all
minus Table 'fileName$'
Remove
select Table 'fileName$'
if rectangle != 1
	Font size... 10
endif


