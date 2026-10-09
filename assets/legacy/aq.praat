# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明（beixianming@163.com）编写。
#本脚本的功能是查询常见汉字中古音地位，并给出八位学者的中古拟音。
#中古音地位信息来自刘村汉教授的excel方言处理软件和网上“古今字音对照字表”。删除了少数不方便处理的汉字。
#八位学者拟音的音系来自李新魁教授《汉语音韵学》，北京出版社，1986年。周法高的两个并列韵母后者增加了括号。
#2019.10.03

form set parameters
	sentence hanzi 好
endform

Read from file... 'legacyResourceDirectory$'/中古声母拟音表.txt
Read from file... 'legacyResourceDirectory$'/中古韵母拟音表.txt
Read from file... 'legacyResourceDirectory$'/汉字音韵表.txt
numberOfRowsYinYunBiao = Get number of rows
boundary = Search column... 字目 #
clearinfo
printNumber = 0
 hanziNumber = 0
printline 行数	汉字	声(组)	韵(摄、开合、等列)	古调	高本汉	赵元任	王力	陆志韦	方孝岳	李方桂	董同龢	周法高	李荣
printline =============
for i from 1 to numberOfRowsYinYunBiao
	select Table 汉字音韵表
	string$ = Get value... i 字目
	if string$ = hanzi$
		gusheng$ = Get value... i 古声
		shengzu$ = Get value... i 声组
		guyun$ = Get value... i 古韵
		yunshe$ = Get value... i 韵摄
		gudiao$ = Get value... i 古调
		kaihe$ = Get value... i 开合
		denglie$ = Get value... i 等列
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
			if i > boundary and printNumber = 0
				printline -------------
				printNumber = printNumber + 1
			endif
			printline 'i'行'tab$''hanzi$''tab$''gusheng$'('shengzu$')'tab$''guyun$'('yunshe$''kaihe$''denglie$')'tab$''gudiao$'声'tab$''gaobenhan$''tab$''zhaoyuanren$''tab$''wangli$''tab$''luzhiwei$''tab$''fangxiaoyue$''tab$''lifanggui$''tab$''dongtonghe$''tab$''zhoufagao$''tab$''lirong$'
			hanziNumber = hanziNumber + 1
	elsif i = numberOfRowsYinYunBiao and hanziNumber = 0
		printline 抱歉，查询系统中不存在"'hanzi$'"的中古音信息。
	endif
endfor
printline =============
printline 说明：行数小于'boundary'的，是根据刘村汉教授excel方言处理软件音韵地位检索的结果。
printline       行数大于'boundary'的，是根据网上“古今字音对照字表”音韵地位检索的结果。
select Table 中古声母拟音表
plus Table 中古韵母拟音表
plus Table 汉字音韵表
Remove

