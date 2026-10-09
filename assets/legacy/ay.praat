legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是检查Table文件中数据的离群值值和极端值。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2020.01.18

form set parameters
choice is_column_label_existed 1
	button no
	button yes
	boolean delete_outliers_and_extreme_values 1
	boolean delete_row_which_contains_undefined 1
	boolean print 0
endform

endeditor
pathFileName$ = chooseReadFile$: "请选择Table文件"
if pathFileName$ = ""
    exitScript: "已取消。"
endif
Modified read analysis table: pathFileName$, ""

fileName$ = selected$("Table")
numberOfColumns = Get number of columns
if is_column_label_existed = 1
	for i from 1 to numberOfColumns
		columnLabelTemp$ = Get column label... i
		if i = 1
			Set column label (label)... 'columnLabelTemp$' content
		elsif i > 1
			j = i - 1
			Set column label (label)... 'columnLabelTemp$' dot'j'
		endif
	endfor
endif

if delete_row_which_contains_undefined = 1
	numberOfRows = Get number of rows
	for inumberOfColumns from 1 to numberOfColumns
		for inumberOfRows from 1 to numberOfRows
			columnLabel$ = Get column label: inumberOfColumns
			value$ = Get value: inumberOfRows, columnLabel$	
			if value$ = "--undefined--"
				Remove row: inumberOfRows
				numberOfRows -= 1
				inumberOfRows -= 1
			endif
		endfor
	endfor
endif

if print = 1
	clearinfo
endif
Append column: "离群值或极端值"
numberOfRows = Get number of rows
firstColumnLabel$ = Get column label... 1
Sort rows... 'firstColumnLabel$'
j = 1
for i from 1 to numberOfRows-1
	select Table 'fileName$'
	string_i$ = Get value... i 'firstColumnLabel$'
	if i = 1
		Extract rows where column (text)... 'firstColumnLabel$' "is equal to" 'string_i$'
		call quantile
	elsif i > 1
		k = i + 1
		string_k$ = Get value... k 'firstColumnLabel$'
		if string_i$ != string_k$
			j = j + 1
			Extract rows where column (text)... 'firstColumnLabel$' "is equal to" 'string_k$'
			call quantile
		endif
	endif
endfor
select Table 'fileName$'
Remove
select all
Append
if delete_outliers_and_extreme_values = 1
	numberOfRows = Get number of rows
	for inumberOfRows to numberOfRows
		string$ = Get value: inumberOfRows, "离群值或极端值"
		if string$ = "离" or string$ = "极"
			Remove row: inumberOfRows
			numberOfRows -= 1
			inumberOfRows -= 1
		endif
	endfor
	Remove column: "离群值或极端值"
endif
appendInfoLine: "完成，请手动保存主界面中的新文件!"

procedure quantile
	numberOfRowsTemp = Get number of rows
	if numberOfRowsTemp < 4
		if i = 1
			string_x$ = string_i$
		else
			string_x$ = string_k$
		endif
		printline 'string_x$'少于4行，软件不能检查离群值和极端值，请进行人工检查。
	elsif numberOfRowsTemp >= 4
		for x from 2 to numberOfColumns
			columnLabelTemp$ = Get column label... x
			Sort rows... 'columnLabelTemp$'
			q1=Get quantile... 'columnLabelTemp$' 0.25
			q3=Get quantile... 'columnLabelTemp$' 0.75
			for y from 1 to numberOfRowsTemp
				if i = 1
					string_x$ = string_i$
				else
					string_x$ = string_k$
				endif
				valueTemp = Get value... y 'columnLabelTemp$'
				if (q1 - valueTemp) / (q3 - q1) > 1.5 and (q1 - valueTemp) / (q3 - q1) <= 3
					if print = 1
						printline 'string_x$'的'columnLabelTemp$'有离群值:'valueTemp'
					endif
					Set string value: y, "离群值或极端值", "离"
				elsif (q1 - valueTemp) / (q3 - q1) > 3
					if print = 1
						printline 'string_x$'的'columnLabelTemp$'有极端值:'valueTemp'
					endif
					Set string value: y, "离群值或极端值", "极"
				elsif (valueTemp - q3) / (q3 - q1) > 1.5 and (valueTemp - q3) / (q3 - q1) <= 3
					if print = 1
						printline 'string_x$'的'columnLabelTemp$'有离群值:'valueTemp'
					endif
					Set string value: y, "离群值或极端值", "离"
				elsif (valueTemp - q3) / (q3 - q1) > 3
					if print = 1
						printline 'string_x$'的'columnLabelTemp$'有极端值:'valueTemp'
					endif
					Set string value: y, "离群值或极端值", "极"
				endif
			endfor
		endfor
	endif
endproc