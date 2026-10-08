legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是解决第一列出现乱码的问题（多为软件自动保存的xls文件）。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2021.02.24

form set parameters
	natural numberOfColumn 1
endform
fileName$ = chooseReadFile$: "请选择第一列出现乱码的文件"
if fileName$ <> ""
	Read from file: fileName$
	numberOfRows = Get number of rows
	clearinfo
	comumnLabel$ = Get column label: 'numberOfColumn'
	printline 'comumnLabel$'
	for i to numberOfRows
		value$ = Get value... i 'comumnLabel$'
		printline 'value$'
	endfor
endif
Remove
exit 请将信息窗口的内容复制粘贴到第一列出现乱码的文件里。