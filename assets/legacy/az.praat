# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对able文件数据的描述性统计（和、最小值、最大值、标准差、变异系数）。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2020.01.18

form set parameters
comment 注意 本菜单只适合于第1列为索引，从第2列开始为数据的文件。
choice is_column_label_existed 1
	button no
	button yes
endform

endeditor
pathFileName$ = chooseReadFile$: "请选择Table文件"
if pathFileName$ = ""
    exitScript: "已取消。"
endif
# jeoitim：保留原脚本的空格转制表符并写回步骤；改写前在输入目录备份原文件。
Modified format analysis text: pathFileName$
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
clearinfo
printline 列数'tab$'行名'tab$'列名'tab$'和'tab$'最小值'tab$'最大值'tab$'平均值'tab$'标准差'tab$'变异系数
fileName$ = selected$("Table")
numberOfRows = Get number of rows
firstColumnLabel$ = Get column label... 1
Sort rows... 'firstColumnLabel$'
j = 1
for i from 1 to numberOfRows-1
	select Table 'fileName$'
	string_i$ = Get value... i 'firstColumnLabel$'
	if i = 1
		Extract rows where column (text)... 'firstColumnLabel$' "is equal to" 'string_i$'
		fileName1$ = selected$("Table")
		call mean_std_cv
		Remove
	elsif i > 1
		k = i + 1
		string_k$ = Get value... k 'firstColumnLabel$'
		if string_i$ != string_k$
			j = j + 1
			Extract rows where column (text)... 'firstColumnLabel$' "is equal to" 'string_k$'
			fileName1$ = selected$("Table")
			call mean_std_cv
			Remove
		endif
	endif
endfor
select Table 'fileName$'
appendInfoLine: "完成!"

procedure mean_std_cv
	numberOfRowsTemp = Get number of rows
	for x from 2 to numberOfColumns
		select Table 'fileName1$'
		Append
		fileName2$ = selected$("Table")
		numberOfRowsTemp = Get number of rows
		columnLabelTemp$ = Get column label... x
		for xx from 1 to numberOfRowsTemp
			value = Get value... 'xx' 'columnLabelTemp$'
			y = value * 0
			y$ = "'y'"
			times = 0
			if y$ = "--undefined--"
				Remove row... 'xx'
				numberOfRowsTemp = numberOfRowsTemp - 1
				times = times + 1
			endif
			if times != 0
				printline 下一行'columnLabelTemp$'的统计删除了'times'行带有非数值的数据，统计结果将不同于英文版praat，而同于excel！
			endif
		endfor
		numberOfRowsTemp = Get number of rows
		columnLabelTemp$ = Get column label... x
		min = Get minimum... 'columnLabelTemp$'
		max = Get maximum... 'columnLabelTemp$'
		mean = Get mean... 'columnLabelTemp$'
		std = Get standard deviation... 'columnLabelTemp$'
		cv = std / mean
		sum = 0
		count = 0
		for xx from 1 to numberOfRowsTemp
			value = Get value... 'xx' 'columnLabelTemp$'
			sum = sum + value
		endfor
		if i = 1
			string_x$ = string_i$
		else
			string_x$ = string_k$
		endif
		if mean > 10
			printline 'numberOfRowsTemp''tab$''string_x$''tab$''columnLabelTemp$''tab$''sum''tab$''min:0''tab$''max:0''tab$''mean:0''tab$''std:3''tab$''cv:3'
		else
			printline 'numberOfRowsTemp''tab$''string_x$''tab$''columnLabelTemp$''tab$''sum''tab$''min:3''tab$''max:3''tab$''mean:3''tab$''std:3''tab$''cv:3'
		endif
		select Table 'fileName2$'
		Remove
	endfor
	select Table 'fileName1$'
endproc