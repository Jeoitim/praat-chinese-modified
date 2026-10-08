legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是在V值图中画箭头。
#请在主编辑器中运行本脚本。需要读入V值表。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.04.08

form set patameters
sentence 注意： 若是双元音，则不填startIPA。
	choice picture_type 1
		button 两图垂直呈现
		button 两图水平呈现
sentence startIPA u(ai)
sentence middleIPA (u)a(i)
sentence endIPA (ua)i
endform

if "'middleIPA$'" = "" or "'endIPA$'" = ""
exit middleIPA和endIPA不能为空！
endif
middleIPA$ = backslashTrigraphsToUnicode$(middleIPA$)
middleIPA$ = replace$(middleIPA$, "（", "(", 0)
middleIPA$ = replace$(middleIPA$, "）", ")", 0)
index = index(middleIPA$,"-")
if index = 3
	right$ = right$(middleIPA$, 1)
	middleIPA$ = middleIPA$ - right$(middleIPA$, 2)
	if right$ = "1"
		middleIPA$ = left$(middleIPA$, 1) + "(" + mid$(middleIPA$, 2, 1) + ")"
	elsif right$ = "2"
		middleIPA$ = "(" + left$(middleIPA$, 1) + ")" + mid$(middleIPA$, 2, 1)
	endif
endif
if index = 4
	right$ = right$(middleIPA$, 1)
	middleIPA$ = middleIPA$ - right$(middleIPA$, 2)
	if right$ = "1"
		middleIPA$ = left$(middleIPA$, 1) + "(" + mid$(middleIPA$, 2, 2) + ")"
	elsif right$ = "2"
		middleIPA$ = "(" + left$(middleIPA$, 1) + ")" + mid$(middleIPA$, 2, 1) + "(" + mid$(middleIPA$, 3, 1) + ")"
	elsif right$ = "3"
		middleIPA$ = "(" + mid$(middleIPA$, 1, 2)  + ")" + mid$(middleIPA$, 3, 1)
	endif
endif
endIPA$ = backslashTrigraphsToUnicode$(endIPA$)
endIPA$ = replace$(endIPA$, "（", "(", 0)
endIPA$ = replace$(endIPA$, "）", ")", 0)
index = index(endIPA$,"-")
if index = 3
	right$ = right$(endIPA$, 1)
	endIPA$ = endIPA$ - right$(endIPA$, 2)
	if right$ = "1"
		endIPA$ = left$(endIPA$, 1) + "(" + mid$(endIPA$, 2, 1) + ")"
	elsif right$ = "2"
		endIPA$ = "(" + left$(endIPA$, 1) + ")" + mid$(endIPA$, 2, 1)
	endif
endif
if index = 4
	right$ = right$(endIPA$, 1)
	endIPA$ = endIPA$ - right$(endIPA$, 2)
	if right$ = "1"
		endIPA$ = left$(endIPA$, 1) + "(" + mid$(endIPA$, 2, 2) + ")"
	elsif right$ = "2"
		endIPA$ = "(" + left$(endIPA$, 1) + ")" + mid$(endIPA$, 2, 1) + "(" + mid$(endIPA$, 3, 1) + ")"
	elsif right$ = "3"
		endIPA$ = "(" + mid$(endIPA$, 1, 2)  + ")" + mid$(endIPA$, 3, 1)
	endif
endif

if "'middleIPA$'" <> "" and "'endIPA$'" <> ""
rowOfMiddleIPA = Search column... vowel 'middleIPA$'
if rowOfMiddleIPA = 0
exit 找不到该复元音！
endif
v1Middle = Get value... rowOfMiddleIPA F1
v2Middle = Get value... rowOfMiddleIPA F2
v3subt2Middle = Get value... rowOfMiddleIPA F3-F2
rowOfEndIPA = Search column... vowel 'endIPA$'
if rowOfEndIPA = 0
exit 找不到该复元音！
endif
v1End = Get value... rowOfEndIPA F1
v2End = Get value... rowOfEndIPA F2
v3subt2End = Get value... rowOfEndIPA F3-F2
if v2Middle > v2End
v2Middle = v2Middle - abs(v2Middle - v2End)*0.1*1.37
v2End = v2End + abs(v2Middle - v2End)*0.1*1.37
endif
if v2Middle < v2End
v2Middle = v2Middle + abs(v2Middle - v2End)*0.1*1.37
v2End = v2End - abs(v2Middle - v2End)*0.1*1.37
endif
if v3subt2Middle > v3subt2End
v3subt2Middle = v3subt2Middle - abs(v3subt2Middle - v3subt2End)*0.1*1.37
v3subt2End = v3subt2End + abs(v3subt2Middle - v3subt2End)*0.1*1.37
endif
if v3subt2Middle < v3subt2End
v3subt2Middle = v3subt2Middle + abs(v3subt2Middle - v3subt2End)*0.1*1.37
v3subt2End = v3subt2End - abs(v3subt2Middle - v3subt2End)*0.1*1.37
endif
if v1Middle > v1End
v1Middle = v1Middle - abs(v1Middle - v1End)*0.1
v1End = v1End + abs(v1Middle - v1End)*0.1
endif
if v1Middle < v1End
v1Middle = v1Middle + abs(v1Middle - v1End)*0.1
v1End = v1End - abs(v1Middle - v1End)*0.1
endif
Select outer viewport... 0 6 0 4
Axes... 100 0 100 0 
Draw arrow... v2Middle v1Middle v2End v1End
if picture_type = 1
	Select outer viewport... 0 6 4 8
elsif picture_type = 2
	Select outer viewport... 6 12 0 4
endif
Axes... 0 100 100 0 
Draw arrow... v3subt2Middle v1Middle v3subt2End v1End

if "'startIPA$'" <> ""
startIPA$ = backslashTrigraphsToUnicode$(startIPA$)
startIPA$ = replace$(startIPA$, "（", "(", 0)
startIPA$ = replace$(startIPA$, "）", ")", 0)
index = index(startIPA$,"-")
if index = 3
	right$ = right$(startIPA$, 1)
	startIPA$ = startIPA$ - right$(startIPA$, 2)
	if right$ = "1"
		startIPA$ = left$(startIPA$, 1) + "(" + mid$(startIPA$, 2, 1) + ")"
	elsif right$ = "2"
		startIPA$ = "(" + left$(startIPA$, 1) + ")" + mid$(startIPA$, 2, 1)
	endif
endif
if index = 4
	right$ = right$(startIPA$, 1)
	startIPA$ = startIPA$ - right$(startIPA$, 2)
	if right$ = "1"
		startIPA$ = left$(startIPA$, 1) + "(" + mid$(startIPA$, 2, 2) + ")"
	elsif right$ = "2"
		startIPA$ = "(" + left$(startIPA$, 1) + ")" + mid$(startIPA$, 2, 1) + "(" + mid$(startIPA$, 3, 1) + ")"
	elsif right$ = "3"
		startIPA$ = "(" + mid$(startIPA$, 1, 2)  + ")" + mid$(startIPA$, 3, 1)
	endif
endif
rowOfStartIPA = Search column... vowel 'startIPA$'
if rowOfStartIPA = 0
exit 找不到该复元音！
endif
v1Start = Get value... rowOfStartIPA F1
v2Start = Get value... rowOfStartIPA F2
v3subt2Start = Get value... rowOfStartIPA F3-F2
v1Middle = Get value... rowOfMiddleIPA F1
v2Middle = Get value... rowOfMiddleIPA F2
v3subt2Middle = Get value... rowOfMiddleIPA F3-F2
if v2Start > v2Middle
v2Start = v2Start - abs(v2Start - v2Middle)*0.1*1.37
v2Middle = v2Middle + abs(v2Start - v2Middle)*0.1*1.37
endif
if v2Start < v2Middle
v2Start = v2Start + abs(v2Start - v2Middle)*0.1*1.37
v2Middle = v2Middle - abs(v2Start - v2Middle)*0.1*1.37
endif
if v3subt2Start > v3subt2Middle
v3subt2Start = v3subt2Start - abs(v3subt2Start - v3subt2Middle)*0.1*1.37
v3subt2Middle = v3subt2Middle + abs(v3subt2Start - v3subt2Middle)*0.1*1.37
endif
if v3subt2Start < v3subt2Middle
v3subt2Start = v3subt2Start + abs(v3subt2Start - v3subt2Middle)*0.1*1.37
v3subt2Middle = v3subt2Middle - abs(v3subt2Start - v3subt2Middle)*0.1*1.37
endif
if v1Start > v1Middle
v1Start = v1Start - abs(v1Start - v1Middle)*0.1
v1Middle = v1Middle + abs(v1Start - v1Middle)*0.1
endif
if v1Start < v1Middle
v1Start = v1Start + abs(v1Start - v1Middle)*0.1
v1Middle = v1Middle - abs(v1Start - v1Middle)*0.1
endif
Select outer viewport... 0 6 0 4
Axes... 100 0 100 0 
Draw arrow... v2Start v1Start v2Middle v1Middle
if picture_type = 1
	Select outer viewport... 0 6 4 8
elsif picture_type = 2
	Select outer viewport... 6 12 0 4
endif
Axes... 0 100 100 0 
Draw arrow... v3subt2Start v1Start v3subt2Middle v1Middle
endif
endif
Select outer viewport... 0 6 0 4