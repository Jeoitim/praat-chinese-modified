# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是古文中古音拟音。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2023.06.16

form set parameters
	choice expert 3
		button 高本汉
		button 赵元任
		button 王力
		button 陆志韦
		button 方孝岳
		button 李方桂
		button 董同龢
		button 周法高
		button 李荣
endform

clearinfo
hanziNumber = 0
pathFileName$ = chooseReadFile$: "请选择诗词的txt文件"
if pathFileName$ != ""
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
	Read from file... 'legacyResourceDirectory$'/中古声母拟音表.txt
	Read from file... 'legacyResourceDirectory$'/中古韵母拟音表.txt
	Read from file... 'legacyResourceDirectory$'/汉字音韵表.txt
	numberOfRowsYinYunBiao = Get number of rows
	for i from 1 to numberOfStrings
		select Strings 'stringsFileName$'
		string$ = Get string: i
		appendInfoLine: string$
		length = length(string$)
		for j to length
			hanzi$ = mid$(string$, j, 1)
			number0 = 0
			number1 = 0
			for k from 3942 to numberOfRowsYinYunBiao
				select Table 汉字音韵表
				stringTemp$ = Get value... k 字目
				if stringTemp$ = hanzi$
					number0 += 1
					gusheng$ = Get value... k 古声
					shengzu$ = Get value... k 声组
					guyun$ = Get value... k 古韵
					yunshe$ = Get value... k 韵摄
					gudiao$ = Get value... k 古调
					kaihe$ = Get value... k 开合
					denglie$ = Get value... k 等列
					select Table 中古声母拟音表
					Extract rows where column (text)... 古声 "is equal to" 'gusheng$'
					gaobenhanshengmu$ = Get value... 1 高本汉
					zhaoyuanrenshengmu$ = Get value... 1 赵元任
					wanglishengmu$ = Get value... 1 王力
					luzhiweishengmu$ = Get value... 1 陆志韦
					fangxiaoyueshengmu$ = Get value... 1 方孝岳
					lifangguishengmu$ = Get value... 1 李方桂
					dongtongheshengmu$ = Get value... 1 董同龢
	 				zhoufagaoshengmu$ = Get value... 1 周法高
					lirongshengmu$ = Get value... 1 李荣
					if denglie$ = "二"
						fangxiaoyueshengmu$ =  replace$ (fangxiaoyueshengmu$, "ȶ", "ʈ", 0)
						fangxiaoyueshengmu$ =  replace$ (fangxiaoyueshengmu$, "ȶʻ", "ʈʻ", 0)
						fangxiaoyueshengmu$ =  replace$ (fangxiaoyueshengmu$, "ȡʻ", "dʻ", 0)
						fangxiaoyueshengmu$ =  replace$ (fangxiaoyueshengmu$, "ȵ", "n", 0)
					endif
					Remove

					select Table 中古韵母拟音表
					Extract rows where column (text)... 古韵 contains 'guyun$'
					Extract rows where column (text)... 开合 "is equal to" 'kaihe$'
					rowTemp = Get number of rows
					if rowTemp = 0
						Remove
						goto exitLoop
					endif
					gaobenhanyunmu$ = Get value... 1 高本汉
					zhaoyuanrenyunmu$ = Get value... 1 赵元任
					wangliyunmu$ = Get value... 1 王力
					luzhiweiyunmu$ = Get value... 1 陆志韦
					fangxiaoyueyunmu$ = Get value... 1 方孝岳
					lifangguiyunmu$ = Get value... 1 李方桂
					dongtongheyunmu$ = Get value... 1 董同龢
	 				zhoufagaoyunmu$ = Get value... 1 周法高
					lirongyunmu$ = Get value... 1 李荣
					if gudiao$ = "入"
						gaobenhanyunmu$ = replace$ (gaobenhanyunmu$, "m", "p", 0)
						zhaoyuanrenyunmu$ = replace$ (zhaoyuanrenyunmu$, "m", "p", 0)
						wangliyunmu$ = replace$ (wangliyunmu$, "m", "p", 0)
						luzhiweiyunmu$ =  replace$ (luzhiweiyunmu$, "m", "p", 0)
						fangxiaoyueyunmu$ =  replace$ (fangxiaoyueyunmu$, "m", "p", 0)
						lifangguiyunmu$ =  replace$ (lifangguiyunmu$, "m", "p", 0)
						dongtongheyunmu$ =  replace$ (dongtongheyunmu$, "m", "p", 0)
	 					zhoufagaoyunmu$ =  replace$ (zhoufagaoyunmu$, "m", "p", 0)
						lirongyunmu$ =  replace$ (lirongyunmu$, "m", "p", 0)
						gaobenhanyunmu$ = replace$ (gaobenhanyunmu$, "n", "t", 0)
						zhaoyuanrenyunmu$ = replace$ (zhaoyuanrenyunmu$, "n", "t", 0)
						wangliyunmu$ = replace$ (wangliyunmu$, "n", "t", 0)
						luzhiweiyunmu$ =  replace$ (luzhiweiyunmu$, "n", "t", 0)
						fangxiaoyueyunmu$ =  replace$ (fangxiaoyueyunmu$, "n", "t", 0)
						lifangguiyunmu$ =  replace$ (lifangguiyunmu$, "n", "t", 0)
						dongtongheyunmu$ =  replace$ (dongtongheyunmu$, "n", "t", 0)
	 					zhoufagaoyunmu$ =  replace$ (zhoufagaoyunmu$, "n", "t", 0)
						lirongyunmu$ =  replace$ (lirongyunmu$, "n", "t", 0)
						gaobenhanyunmu$ = replace$ (gaobenhanyunmu$, "ŋ", "k", 0)
						zhaoyuanrenyunmu$ = replace$ (zhaoyuanrenyunmu$, "ŋ", "k", 0)
						wangliyunmu$ = replace$ (wangliyunmu$, "ŋ", "k", 0)
						luzhiweiyunmu$ =  replace$ (luzhiweiyunmu$, "ŋ", "k", 0)
						fangxiaoyueyunmu$ =  replace$ (fangxiaoyueyunmu$, "ŋ", "k", 0)
						lifangguiyunmu$ =  replace$ (lifangguiyunmu$, "ŋ", "k", 0)
						dongtongheyunmu$ =  replace$ (dongtongheyunmu$, "ŋ", "k", 0)
	 					zhoufagaoyunmu$ =  replace$ (zhoufagaoyunmu$, "ŋ", "k", 0)
						lirongyunmu$ =  replace$ (lirongyunmu$, "ŋ", "k", 0)
					endif
					gaobenhan$ = gaobenhanshengmu$ + gaobenhanyunmu$
					zhaoyuanren$ = zhaoyuanrenshengmu$ + zhaoyuanrenyunmu$
					wangli$ = wanglishengmu$ + wangliyunmu$
					luzhiwei$ = luzhiweishengmu$ + luzhiweiyunmu$
					fangxiaoyue$ =  fangxiaoyueshengmu$ + fangxiaoyueyunmu$
					lifanggui$ = lifangguishengmu$ + lifangguiyunmu$
					dongtonghe$ = dongtongheshengmu$ + dongtongheyunmu$
	 				zhoufagao$ =  zhoufagaoshengmu$ + zhoufagaoyunmu$
					lirong$ = lirongshengmu$ + lirongyunmu$
					plus Table 中古韵母拟音表_'guyun$'
					Remove
					if gudiao$ = "平"
						gudiao$ = "1"
					elsif gudiao$ = "上"
						gudiao$ = "2"
					elsif gudiao$ = "去"
						gudiao$ = "3"
					elsif gudiao$ = "入"
						gudiao$ = "4"
					endif
					if expert = 1
						if number1 = 0
							appendInfo: gaobenhan$, " "
						else
							appendInfo: "/", gaobenhan$, " "
						endif
					elsif expert = 2
						if number1 = 0
							appendInfo: zhaoyuanren$, " "
						else
							appendInfo: "/", zhaoyuanren$, " "
						endif
					elsif expert = 3
						if number1 = 0
							appendInfo: wangli$, gudiao$, " "
						else
							appendInfo: "/", wangli$, gudiao$, " "
						endif
					elsif expert = 4
						if number1 = 0
							appendInfo: luzhiwei$, gudiao$, " "
						else
							appendInfo: "/", luzhiwei$, gudiao$, " "
						endif
					elsif expert = 5
						if number1 = 0
							appendInfo: fangxiaoyue$, gudiao$, " "
						else
							appendInfo: "/", fangxiaoyue$, gudiao$, " "
						endif
					elsif expert = 6
						if number1 = 0
							appendInfo: lifanggui$, gudiao$, " "
						else
							appendInfo: "/",lifanggui$, gudiao$, " "
						endif
					elsif expert = 7
						if number1 = 0
							appendInfo: dongtonghe$, gudiao$, " "
						else
							appendInfo: "/",dongtonghe$, gudiao$, " "
						endif
					elsif expert = 8
						if number1 = 0
							appendInfo: zhoufagao$, gudiao$, " "
						else
							appendInfo: "/",zhoufagao$, gudiao$, " "
						endif
					elsif expert = 9
						if number1 = 0
							appendInfo: lirong$, gudiao$, " "
						else
							appendInfo: "/",lirong$, gudiao$, " "
						endif
					endif
					number1 += 1
				endif

			endfor
			if number0 = 0
				appendInfo: hanzi$
			endif
		label exitLoop
		endfor
		appendInfo: newline$
	endfor
endif
appendInfoLine: "-------------------"
if expert = 1
	appendInfoLine: "以上为高本汉的拟音。"
elsif expert = 2
	appendInfoLine: "以上为赵元任的拟音。"
elsif expert = 3
	appendInfoLine: "以上为王力的拟音。"
elsif expert = 4
	appendInfoLine: "以上为陆志韦的拟音。"
elsif expert = 5
	appendInfoLine: "以上为方孝岳的拟音。"
elsif expert = 6
	appendInfoLine: "以上为李方桂的拟音。"
elsif expert = 7
	appendInfoLine: "以上为董同龢的拟音。"
elsif expert = 8
	appendInfoLine: "以上为周法高的拟音。"
elsif expert = 9
	appendInfoLine: "以上为李荣的拟音。"
endif
select Table 中古声母拟音表
plus Table 中古韵母拟音表
plus Table 汉字音韵表
plus Strings 'stringsFileName$'
Remove
appendInfoLine: "完成"