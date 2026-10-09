# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是对指定文件夹中所有txt文件进行文本检索。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.09.30

form set parameters
	comment 注意 语料文件请另存为UTF-8或Unicode编码，避免有乱码检索不到。
	comment 注意 为了速度，别轻易勾选write infomation in Info Window
	sentence folder_path .
	sentence key_word_start 不但
	integer distance 0 (=0 表示无指定间距)
	sentence key_word_end 而且
	sentence punctuation1 。
	sentence punctuation2 ！
	sentence punctuation3 ？
	sentence punctuation4 ……
	boolean write_infomation_in_Info_Window 0
endform
if folder_path$ = "."
    folder_path$ = legacyDataDirectory$
endif

Create Strings as file list... fileList 'folder_path$'/*.txt
numberOfStrings = Get number of strings
if distance < 0
	exit distance必须大于等于0.
endif
if key_word_start$ = "" or key_word_start$ = " "
	exit 请填写key_word_start。
endif
keyword$ = key_word_start$ + key_word_end$
if index(keyword$, "/") or index(keyword$, "\")
    exitScript: "检索词包含路径分隔符，请改用普通检索词。"
endif
fileReadable=fileReadable("'legacyDataDirectory$'/'keyword$'.txt")
if fileReadable = 1
	pause 'keyword$'.txt已在，请移走，它将参与检索，且结果将附其中！
endif
clearinfo
for times from 1 to numberOfStrings
	select Strings fileList
	fileName$ = Get string... times
	Read Strings from raw text file... 'folder_path$'/'fileName$'
	fileName$ = fileName$ - ".txt"
	call search
endfor
select Strings fileList
Remove
date$ = date$()
fileappend "'legacyDataDirectory$'/'keyword$'.txt" 检索时间：'date$''newline$'
exit 全部检索完毕，请到'legacyDataDirectory$'/'keyword$'.txt查看结果！

procedure search
numberOfSrings = Get number of strings
sum = 0
for i from 1 to numberOfSrings
	string$ = Get string... i
	n = i
	repeat
	j = 1
	k = 1
	m = 0
	newStringsStart$ = ""
	newStringsEnd$ = ""
	lengthOfStrings = length (string$)
	lengthOfKeyWordStart = length (key_word_start$)
	whereIsKey_word_start = index_regex (string$, key_word_start$)
	if whereIsKey_word_start != 0
		repeat
			newStringsEnd$ = mid$ (string$, whereIsKey_word_start, j)
			j = j + 1
			whereEnd1 = endsWith (newStringsEnd$, punctuation1$)
			whereEnd2 = endsWith (newStringsEnd$, punctuation2$)
			whereEnd3 = endsWith (newStringsEnd$, punctuation3$)
			whereEnd4 = endsWith (newStringsEnd$, punctuation4$)
		until whereEnd1 = 1 or whereEnd2 = 1 or whereEnd3 = 1 or whereEnd4 = 1 or lengthOfStrings - whereIsKey_word_start = j - 2
		newStringsEnd$ = mid$ (string$, whereIsKey_word_start, j - 1)
		if whereIsKey_word_start = 1
			newStringsStart$ = ""
		elsif whereIsKey_word_start != 1
			repeat
				newStringsStart$ = mid$ (string$, whereIsKey_word_start - k + 1, k)
				k = k + 1
				whereStart1 = startsWith (newStringsStart$, punctuation1$)
				whereStart2 = startsWith (newStringsStart$, punctuation2$)
				whereStart3 = startsWith (newStringsStart$, punctuation3$)
				whereStart4 = startsWith (newStringsStart$, punctuation4$)
			until whereStart1 = 1 or  whereStart2 = 1 or  whereStart3 = 1 or  whereStart4 = 1 or whereIsKey_word_start = k
			newStringsStart$ = mid$ (string$, whereIsKey_word_start - k + 1, k - 1)
			tempString$ = left$ (newStringsStart$, 1)
			if tempString$ = punctuation1$ or tempString$ = punctuation2$ or tempString$ = punctuation3$ or tempString$ = punctuation4$
				lengthOfStartString = length (newStringsStart$)
				newStringsStart$ = right$ (newStringsStart$, lengthOfStartString - 1)
			endif
			tempString$ = mid$ (newStringsStart$, 2, 1)
			if tempString$ = punctuation1$ or tempString$ = punctuation2$ or tempString$ = punctuation3$ or tempString$ = punctuation4$
				lengthOfStartString = length (newStringsStart$)
				newStringsStart$ = right$ (newStringsStart$, lengthOfStartString - 2)
			endif
		endif
		if key_word_end$ = "" or key_word_end$ = " "
			if n = i
				all$ = newStringsStart$ + newStringsEnd$
			elsif n != i
				all$ = "......" + newStringsStart$ + newStringsEnd$
			endif
			sum = sum + 1
			if write_infomation_in_Info_Window = 1
				printline 第'i'段总第'sum'个：   'all$''tab$'——'fileName$'
			endif
			fileappend "'legacyDataDirectory$'/'keyword$'.txt" 第'i'段总第'sum'个：   'all$''tab$'——'fileName$''newline$'
		elsif key_word_end$ != "" and key_word_end$ != " "
			if distance != 0
				if n = i
					all$ = newStringsStart$ + newStringsEnd$
				elsif n != i
					all$ = "......" + newStringsStart$ + newStringsEnd$
				endif
				o = 1
				repeat
					whereIsKey_word_end2 = index_regex (all$, key_word_end$)
					whereIsKey_word_start2 = index_regex (all$, key_word_start$)
					if o = 1
						if whereIsKey_word_start2 != 0 and whereIsKey_word_end2 != 0 and whereIsKey_word_end2 = whereIsKey_word_start2 + (lengthOfKeyWordStart - 1) + distance + 1
							sum = sum + 1
							if write_infomation_in_Info_Window = 1
								printline 第'i'段总第'sum'个：   'all$''tab$'——'fileName$'
							endif
							fileappend "'legacyDataDirectory$'/'keyword$'.txt" 第'i'段总第'sum'个：   'all$''tab$'——'fileName$''newline$'
						endif
					elsif o != 1
						if whereIsKey_word_start2 != 0 and whereIsKey_word_end2 != 0 and whereIsKey_word_end2 = whereIsKey_word_start2 + (lengthOfKeyWordStart - 1) + distance + 1
							sum = sum + 1
							if write_infomation_in_Info_Window = 1
								printline 第'i'段总第'sum'个：  ......'all$''tab$'——'fileName$'
							endif
							fileappend "'legacyDataDirectory$'/'keyword$'.txt" 第'i'段总第'sum'个：  ......'all$''tab$'——'fileName$''newline$'
						endif
					endif
					lengthOfAlls = length (all$)
					all$ = right$ (all$, lengthOfAlls - whereIsKey_word_end2)
					whereIsKey_word_end2 = index_regex (all$, key_word_end$)
					whereIsKey_word_start2 = index_regex (all$, key_word_start$)
					o = o + 1
				until whereIsKey_word_start2 = 0 or whereIsKey_word_end2 = 0
			elsif distance = 0
				if n = i
					all$ = newStringsStart$ + newStringsEnd$
				elsif n != i
					all$ = "......" + newStringsStart$ + newStringsEnd$
				endif
				p = 1
				repeat
					whereIsKey_word_end2 = index_regex (all$, key_word_end$)
					whereIsKey_word_start2 = index_regex (all$, key_word_start$)
					if p = 1
						if whereIsKey_word_start2 != 0 and whereIsKey_word_end2 != 0 and whereIsKey_word_end2 > whereIsKey_word_start2
							sum = sum + 1
							if write_infomation_in_Info_Window = 1
								printline 第'i'段总第'sum'个：   'all$''tab$'——'fileName$'
							endif
							fileappend "'legacyDataDirectory$'/'keyword$'.txt" 第'i'段总第'sum'个：   'all$''tab$'——'fileName$''newline$'
						endif
					elsif p != 1
						if whereIsKey_word_start2 != 0 and whereIsKey_word_end2 != 0 and whereIsKey_word_end2 > whereIsKey_word_start2
							sum = sum + 1
							if write_infomation_in_Info_Window = 1
								printline 第'i'段总第'sum'个：  ......'all$'
							endif
							fileappend "'legacyDataDirectory$'/'keyword$'.txt" 第'i'段总第'sum'个：  ......'all$''newline$'
						endif
					endif
					lengthOfAlls = length (all$)
					all$ = right$ (all$,lengthOfAlls - whereIsKey_word_end2)
					whereIsKey_word_end2 = index_regex (all$, key_word_end$)
					whereIsKey_word_start2 = index_regex (all$, key_word_start$)
					p = p + 1
				until whereIsKey_word_start2 = 0 or whereIsKey_word_end2 = 0
			endif
		endif
	endif
	string$ = right$ (string$, lengthOfStrings - whereIsKey_word_start)
	n = n + 1
	until whereIsKey_word_start = 0
endfor
fileappend "'legacyDataDirectory$'/'keyword$'.txt" 本次共检索了"'fileName$'.txt"中的'numberOfSrings'段话，共有'sum'个检索结果。
fileappend "'legacyDataDirectory$'/'keyword$'.txt" 'newline$'================================'newline$'
printline 本次共检索了"'fileName$'.txt"中的'numberOfSrings'段话，共有'sum'个检索结果。
printline 第'times'个文件检索完毕！
Remove
endproc
