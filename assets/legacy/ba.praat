# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是计算Table文件中数据的偏度和峰度。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2020.01.29

form set parameters
choice is_column_label_existed 1
	button no
	button yes
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
clearinfo
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
		call skewness_kurtosis
		Remove
	elsif i > 1
		k = i + 1
		string_k$ = Get value... k 'firstColumnLabel$'
		if string_i$ != string_k$
			j = j + 1
			Extract rows where column (text)... 'firstColumnLabel$' "is equal to" 'string_k$'
			call skewness_kurtosis
			Remove
		endif
	endif
endfor
select Table 'fileName$'
appendInfoLine: "完成!"

procedure skewness_kurtosis
	numberOfRowsTemp = Get number of rows
	for x from 2 to numberOfColumns
		columnLabelTemp$ = Get column label... x
		mean = Get mean... 'columnLabelTemp$'
		x2 = 0
		x3 = 0
		x4 = 0
		for y from 1 to numberOfRowsTemp
			value = Get value... y 'columnLabelTemp$'
			x2 = x2 + (value - mean)^2
			x3 = x3 + (value - mean)^3
			x4 = x4 + (value - mean)^4
		endfor
		if i = 1
			string_x$ = string_i$
		else
			string_x$ = string_k$
		endif
		n = numberOfRowsTemp
		if x2 * 0 != 0 or x3 * 0 != 0
			printline 'string_x$'的'columnLabelTemp$'的偏度(skewness)为：--undefined--
		else
			skewness = Bei 计算偏度... 'n' 'x2' 'x3'
			printline 'string_x$'的'columnLabelTemp$'的偏度(skewness)为：'skewness:3'
		endif
		if x2 * 0 != 0 or x4 * 0 != 0
			printline 'string_x$'的'columnLabelTemp$'的峰度(kurtosis)为：--undefined--
		else
			kurtosis = Bei 计算峰度... 'n' 'x2' 'x4'
			printline 'string_x$'的'columnLabelTemp$'的峰度(kurtosis)为：'kurtosis:3'
		endif
		standardErrorSkewness = Bei 计算偏度的标准误... 'n'
		standardErrorKurtosis = Bei 计算峰度的标准误... 'n'
		printline 'string_x$'的'columnLabelTemp$'的偏度(skewness)的标准误为：'standardErrorSkewness:3'
		printline 'string_x$'的'columnLabelTemp$'的峰度(kurtosis)的标准误为：'standardErrorKurtosis:3'
		if x2 * 0 != 0 or x3 * 0 != 0
			x1$ = "--undefined--"
		else
			x1 = abs(skewness / standardErrorSkewness)
		endif
		if x2 * 0 != 0 or x4 * 0 != 0
			x2$ = "--undefined--"
		else
			x2 = abs(kurtosis / standardErrorKurtosis)
		endif
		if x2 * 0 != 0 or x3 * 0 != 0
			printline abs(skewness / standardErrorSkewness) = --undefined--，abs(kurtosis / standardErrorKurtosis) = --undefined--
		else
			jb = Bei 计算Jarque-Bera值... 'n' 'skewness' 'kurtosis'
			printline 'string_x$'的'columnLabelTemp$'的Jarque-Bera值为：'jb:3'
		endif
	endfor
endproc