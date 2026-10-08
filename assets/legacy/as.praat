legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是整理同音字表，并自动保存到data\同音字表.txt中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#本脚本功能是整理同音字表，具体步骤请看"同音字表整理使用说明.txt"。
#2019.08.30

form set parameters
	sentence 注意 若方言调查字表中出现了file下声母表或韵母表或声调表没有的音位，
	sentence 注意 则请先将有关音位补充到声母表或韵母表或声调表，再运行本菜单。
endform

endeditor
pathFileName$ = chooseReadFile$: "请选择方言调查字表"
if pathFileName$ != ""
	Read Strings from raw text file: pathFileName$
	stringsFileName$ = selected$("Strings")
	numberOfStrings = Get number of strings
	spacespace$ = " " + " "
	tabtab$ = tab$ + tab$
	for i from 1 to numberOfStrings
		string$ = Get string: i
		string$ = replace$(string$, spacespace$, " ", 0)
		string$ = replace$(string$, " ", tab$, 0)
		repeat
			string$ = replace$(string$, tabtab$, tab$, 0)
		until index(string$, tabtab$) = 0
		Set string: i, string$
		if string$ = "" or string$ = " " or string$ = "	"
			Remove string: i
			numberOfStrings = numberOfStrings - 1
		endif
	endfor
	Save as raw text file: pathFileName$
	Remove
endif
fileReadable = fileReadable(pathFileName$)
if fileReadable = 1
	Read from file: pathFileName$
else
	exit 没有选择文件或文件数据格式有问题。
endif

fileName$ = selected$("Table")
Read Table from whitespace-separated file... 'legacyResourceDirectory$'/声母表.txt
Read Table from whitespace-separated file... 'legacyResourceDirectory$'/韵母表.txt
Read Table from whitespace-separated file... 'legacyResourceDirectory$'/声调表.txt
clearinfo
select Table 'fileName$'
Sort rows... 调
Sort rows... 韵
Sort rows... 声
Append column... 汉字音标
Append column... 汉字聚合
Append column... 声编号
Append column... 韵编号
Append column... 调编号
lableOfColumn1$ = Get column label... 1
lableOfColumn2$ = Get column label... 2
lableOfColumn3$ = Get column label... 3
lableOfColumn4$ = Get column label... 4
lableOfColumn5$ = Get column label... 5
lableOfColumn6$ = Get column label... 6
lableOfColumn7$ = Get column label... 7
lableOfColumn8$ = Get column label... 8
lableOfColumn9$ = Get column label... 9
numberOfColumnsOfZiBiao = Get number of columns
numberOfRowsOfZiBiao = Get number of rows
select Table 声母表
numberOfRowsOfShengMuBiao = Get number of rows
for i from 1 to numberOfRowsOfZiBiao
	select Table 'fileName$'
	valueOfSheng$ = Get value... i 声
	for j from 1 to numberOfRowsOfShengMuBiao
		select Table 声母表
		valueOfShengmu$ = Get value... j 声母音标
		if valueOfSheng$ = valueOfShengmu$
			select Table 声母表
			bianhao$ = Get value... j 声母编号
			select Table 'fileName$'
			Set string value... i 声编号 'bianhao$'
		endif
	endfor
endfor
select Table 韵母表
numberOfRowsOfYunMuBiao = Get number of rows
for i from 1 to numberOfRowsOfZiBiao
	select Table 'fileName$'
	valueOfYun$ = Get value... i 韵
	for j from 1 to numberOfRowsOfYunMuBiao
		select Table 韵母表
		valueOfYunmu$ = Get value... j 韵母音标
		if valueOfYun$ = valueOfYunmu$
			select Table 韵母表
			bianhao$ = Get value... j 韵母编号
			select Table 'fileName$'
			Set string value... i 韵编号 'bianhao$'
		endif
	endfor
endfor
select Table 声调表
numberOfRowsOfShengDiaoBiao = Get number of rows
for i from 1 to numberOfRowsOfZiBiao
	select Table 'fileName$'
	valueOfDiao$ = Get value... i 调
	for j from 1 to numberOfRowsOfShengDiaoBiao
		select Table 声调表
		valueOfShengDiao$ = Get value... j 声调音标
		if valueOfDiao$ = valueOfShengDiao$
			select Table 声调表
			bianhao$ = Get value... j 声调编号
			select Table 'fileName$'
			Set string value... i 调编号 'bianhao$'
		endif
	endfor
endfor
select Table 'fileName$'
for i from 1 to numberOfColumnsOfZiBiao - 6
	valueOfTemp$ = "0.00000000001"
	s = 0
	lableOfColumn$ = Get column label... i
	lableOfColumnTemp$ = Get column label... i+6
	Sort rows... 'lableOfColumnTemp$'
	for j from 1 to numberOfRowsOfZiBiao
		value$ = Get value... j 'lableOfColumn$'
		if value$ != valueOfTemp$
			print 'value$''tab$'
			s = s + 1
			valueOfTemp$ = value$
		endif
	endfor
printline
printline 共有's'个'lableOfColumn$'
printline =========
endfor
for i from 1 to numberOfRowsOfZiBiao - 6
	value01$ = Get value... i 'lableOfColumn1$'
	value02$ = Get value... i 'lableOfColumn2$'
	value03$ = Get value... i 'lableOfColumn3$'
	valueOfSyllable$ = value01$ + value02$ +value03$
	Set string value... i 'lableOfColumn5$' 'valueOfSyllable$'
endfor
Sort rows... 'lableOfColumn5$'
valueOfFirstRow$ = Get value... 1 'lableOfColumn4$'
Set string value... 1 'lableOfColumn6$' 'valueOfFirstRow$'
s = 0
sum = 1
valueOfTemp$ = Get value... 1 'lableOfColumn5$'
	for j from 2 to numberOfRowsOfZiBiao
		valueOfSyllable$ = Get value... j 'lableOfColumn5$'
		if valueOfSyllable$ = valueOfTemp$
			s = j - sum
			valueOfCharacter1$ = Get value... s 'lableOfColumn6$'
			valueOfCharacter2$ = Get value... j 'lableOfColumn4$'
			valueOfCharacterSum$ = valueOfCharacter1$ + valueOfCharacter2$
			Set string value... s 'lableOfColumn6$' 'valueOfCharacterSum$'
			Set string value... j 'lableOfColumn6$' 0
			sum = sum + 1
		elsif valueOfSyllable$ != valueOfTemp$
			valueOfCharacter2$ = Get value... j 'lableOfColumn4$'
			Set string value... j 'lableOfColumn6$' 'valueOfCharacter2$'
			sum = 1
		endif
		valueOfTemp$ = valueOfSyllable$
	endfor

Sort rows... 'lableOfColumn6$'
s = 1
repeat
	value$ = Get value... s 'lableOfColumn6$'
	if value$ = "0"
		s = s + 1
	endif
until value$ != "0"
s = s - 1
for i from 1 to s
	Remove row... 1
endfor
select Table 'fileName$'
Sort rows... 'lableOfColumn8$' 'lableOfColumn7$' 'lableOfColumn9$'
Remove column... 'lableOfColumn4$'
Remove column... 'lableOfColumn7$'
Remove column... 'lableOfColumn8$'
Remove column... 'lableOfColumn9$'
Save as tab-separated file... 'legacyDataDirectory$'/同音字表.txt
select Table 声母表
plus Table 韵母表
plus Table 声调表
plus Table 'fileName$'
Remove
exit 同音字表整理完成！已保存在data\同音字表.txt。