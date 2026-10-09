legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据首列内容检索Table文件。
#请读入Table文件后运行。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.04.26

form set parameters
	choice is_column_label_existed 1
		button no
		button yes
	sentence string a
endform

fileName$ = selected$("Table")
clearinfo
numberOfColumns = Get number of columns
if is_column_label_existed = 1
	Insert row... 1
	for i from 1 to numberOfColumns
		columnLabelTemp$ = Get column label... i
		if i = 1
			Set string value... 1 'columnLabelTemp$' 'columnLabelTemp$'
		elsif i > 1
			Set string value... 1 'columnLabelTemp$' 'columnLabelTemp$'
		endif
		if i = 1
			Set column label (label)... 'columnLabelTemp$' content
		elsif i > 1
			j = i - 1
			Set column label (label)... 'columnLabelTemp$' dot'j'
		endif
	endfor
endif

numberOfRows = Get number of rows
for k from 1 to numberOfColumns
	columnLabel$ = Get column label... k
	if k != numberOfColumns
		print 'columnLabel$''tab$'
	else
		print 'columnLabel$'
		printline
	endif
endfor

columnLabel$ = Get column label... 1
count = 0
for i from 1 to numberOfRows
	value$ = Get value... i 'columnLabel$'
	if value$ = string$
		count = count + 1
		stringAll$ = ""
		for j from 1 to numberOfColumns
			column$ = Get column label... j
			content$ = Get value... i 'column$'
			if j = 1
				stringAll$ = content$
			else
				stringAll$ = stringAll$ + "'tab$'" + content$
			endif
		endfor
		printline 'stringAll$'
	endif
endfor
if count = 0
	clearinfo
	printline 检索的内容在文件里不存在！
endif

