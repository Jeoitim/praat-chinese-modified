legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是在Table或Strings中查找指定内容。
#请读入Table或Strings文件后运行。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.05.01

form set parameters
	comment 请先读入Table或Strings文件
	choice is_column_label_existed 1
		button no
		button yes
	choice content_type 1
		button Table
		button Strings
	choice if_table_then 2
		button 某列
		button 所有列
	choice if_strings_then 2
		button 某条
		button 所有条
	sentence column_label
	sentence strings_number 
	sentence find 
	natural result_for 100
endform

if find$ = ""
	exit 请在find后填入查找的内容！
endif
clearinfo
if content_type = 1 and if_table_then = 1
	if column_label$ = ""
		exit 请在column label后填入查找内容所在列的标题！
	elsif column_label$ != ""
		fileName$ = selected$("Table")
		if is_column_label_existed = 1
			numberOfColumns = Get number of columns
			Insert row... 1
			for i from 1 to numberOfColumns
				columnLabelTemp$ = Get column label... i
				if i = 1
					Set string value... 1 'columnLabelTemp$' 'columnLabelTemp$'
				elsif i > 1
					Set string value... 1 'columnLabelTemp$' 'columnLabelTemp$'
				endif
				Set column label (label)... 'columnLabelTemp$' column'i'
			endfor
		endif
		printline 行数'tab$'列名'tab$'内容
		numberOfRows = Get number of rows
		for i from 1 to numberOfRows
			string$ = Get value... 'i' 'column_label$'
			result = index(string$,find$)
			if result != 0
				printline 'i''tab$''column_label$''tab$''string$'
			endif
		endfor
	endif
elsif content_type = 1 and if_table_then = 2
	fileName$ = selected$("Table")
	if is_column_label_existed = 1
		numberOfColumns = Get number of columns
		Insert row... 1
		for i from 1 to numberOfColumns
			columnLabelTemp$ = Get column label... i
			if i = 1
				Set string value... 1 'columnLabelTemp$' 'columnLabelTemp$'
			elsif i > 1
				Set string value... 1 'columnLabelTemp$' 'columnLabelTemp$'
			endif
			Set column label (label)... 'columnLabelTemp$' column'i'
		endfor
	endif
	numberOfRows = Get number of rows
	numberOfColumns = Get number of columns
	times = 0
	printline 行数'tab$'列名'tab$'内容
	for i from 1 to numberOfRows
		for ii from 1 to numberOfColumns
			column_label$ = Get column label... 'ii'
			string$ = Get value... 'i' 'column_label$'
			result = index(string$,find$)
			if result != 0
				times = times + 1
				if times <= result_for
					printline 'i''tab$''column_label$''tab$''string$'
				elsif times > result_for
					exit 检查找到的内容超过'result_for'条，不再显示。请修改检索数量或用"Bei 文本检索"
				endif
			endif
		endfor
	endfor
elsif content_type = 2 and if_strings_then = 1
	strings_number = number(strings_number$)
	if strings_number$ = "" or strings_number <= 0 or ceiling(strings_number) != floor(strings_number)
		exit 请在strings number后填入查找内容所在段的位次(自然数)！
	else
		fileName$ = selected$("Strings")
		if is_column_label_existed = 2
			Remove string... 1
		endif
		printline 段数'tab$'内容
		string$ = Get string... 'strings_number'
		result = index(string$,find$)
		if result != 0
			printline 'strings_number''tab$''string$'
		endif
	endif
elsif content_type = 2 and if_strings_then = 2
	fileName$ = selected$("Strings")
	if is_column_label_existed = 2
		Remove string... 1
	endif
	numberOfStrings = Get number of strings
	times = 0
	printline 段数'tab$'内容
	for i from 1 to numberOfStrings
		string$ = Get string... 'i'
		result = index(string$,find$)
		if result != 0
			times = times + 1
			if times <= result_for
				printline 'i''tab$''string$'
			elsif times > result_for
				exit 检查找到的内容超过'result_for'条，不再显示。请修改检索数量或用"Bei 文本检索"
			endif
		endif
	endfor
else
	exit 您在对话框中的选择有误，请重新选择！
endif
exit 查找完成！
