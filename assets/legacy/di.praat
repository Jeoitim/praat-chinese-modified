legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是测量基频数据，并将数据自动保存到软件所在文件夹下的data\tone.txt中。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2023.06.16

clearinfo
pathFileName$ = chooseReadFile$: "请选择诗词的txt文件"
if pathFileName$ != ""
	Read from file: "'legacyResourceDirectory$'/汉字音韵表.txt"
	numberOfRows = Get number of rows
	Read Strings from raw text file: pathFileName$
	stringsFileName$ = selected$("Strings")
	numberOfStrings = Get number of strings
	for i from 1 to numberOfStrings
		string$ = Get string: i
		if string$ = "" or string$ = " " or string$ = "	"
			Remove string: i
			numberOfStrings = numberOfStrings - 1
		endif
	endfor
	for i from 1 to numberOfStrings
		select Strings 'stringsFileName$'
		string$ = Get string: i
		appendInfoLine: string$
		length = length(string$)
		for j to length
			guDiaoTemp$ = ""
			guDiao$ = ""
			stringTemp$ = mid$(string$, j, 1)
			select Table 汉字音韵表
			searchColumn = Search column: "字目", "'stringTemp$'"
			if stringTemp$ = "," or stringTemp$ = "." or stringTemp$ = "，" or stringTemp$ = "。" or stringTemp$ = "?" or stringTemp$ = "？"
				guDiao$ = stringTemp$
			elsif searchColumn = 0
				guDiao$ = " "
			else
				for k from 3942 to numberOfRows
					select Table 汉字音韵表
					ziMu$ = Get value: k, "字目"
					if ziMu$ = stringTemp$
						guDiaoTemp$ = Get value: k, "古调"
						guDiaoTemp$ = replace$(guDiaoTemp$, "上", "仄", 0)
						guDiaoTemp$ = replace$(guDiaoTemp$, "去", "仄", 0)
						guDiaoTemp$ = replace$(guDiaoTemp$, "入", "仄", 0)
						if guDiao$ != guDiaoTemp$
							if guDiao$ = ""
								guDiao$ = guDiaoTemp$
							else
								guDiao$ = guDiao$ + "/" + guDiaoTemp$
							endif
						endif
					endif
				endfor
			endif
			if guDiao$ = ""
				guDiao$$ = "?"
			endif
			appendInfo: guDiao$
		endfor
		appendInfo: newline$
	endfor
endif
select Table 汉字音韵表
plus Strings 'stringsFileName$'
Remove
exit 完成


