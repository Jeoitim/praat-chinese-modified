legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
form set parameters
	sentence 古声 
	sentence 古韵 
	sentence 古调 
	sentence 韵摄 
	sentence 开合 
	sentence 等列 
	sentence 清浊 
	boolean clearinfo 1
endform

if clearinfo = 1
	clearinfo
endif
number = 0
Read from file: "'legacyResourceDirectory$'/汉字音韵表.txt"
numberOfRowsAll = Get number of rows
if 古声$ <> "无" and 古声$ <> "" and 古声$ <> " "
	Extract rows where column (text): "古声", "is equal to", 古声$
	appendInfo: "古声 = ", 古声$
	number += 1
endif
if 古韵$ <> "无" and 古韵$ <> "" and 古韵$ <> " "
	Extract rows where column (text): "古韵", "is equal to", 古韵$
	if number = 0
		appendInfo: "古韵 = ", 古韵$
	else
		appendInfo: tab$, "古韵 = ", 古韵$
	endif
	number += 1
endif
if 古调$ <> "无" and 古调$ <> "" and 古调$ <> " "
	Extract rows where column (text): "古调", "is equal to", 古调$
	if number = 0
		appendInfo: "古调 = ", 古调$
	else
		appendInfo: tab$, "古调 = ", 古调$
	endif
	number += 1
endif
if 韵摄$ <> "无" and 韵摄$ <> ""and 韵摄$ <> " "
	Extract rows where column (text): "韵摄", "is equal to", 韵摄$
	if number = 0
		appendInfo: "韵摄 = ", 韵摄$
	else
		appendInfo: tab$, "韵摄 = ", 韵摄$
	endif
	number += 1
endif
if 开合$ <> "无" and 开合$ <> "" and 开合$ <> " "
	Extract rows where column (text): "开合", "is equal to", 开合$
	if number = 0
		appendInfo: "开合 = ", 开合$
	else
		appendInfo: tab$, "开合 = ", 开合$
	endif
	number += 1
endif
if 等列$ <> "无" and 等列$ <> "" and 等列$ <> " "
	Extract rows where column (text): "等列", "is equal to", 等列$
	if number = 0
		appendInfo: "等列 = ", 等列$
	else
		appendInfo: tab$, "等列 = ", 等列$
	endif
	number += 1
endif
if 清浊$ <> "无" and 清浊$ <> "" and 清浊$ <> " "
	Extract rows where column (text): "清浊", "is equal to", 清浊$
	if number = 0
		appendInfo: "清浊 = ", 清浊$
	else
		appendInfo: tab$, "清浊 = ", 清浊$
	endif
	number += 1
endif
if number = 0
	exit 您没有设定查询条件，请重新设定。
endif
numberOfRows = Get number of rows
appendInfoLine: ""
for inumberOfRows to numberOfRows
	if floor(inumberOfRows / 20) = ceiling(inumberOfRows / 20)
		appendInfoLine: ""
	endif
	string$ = Get value: inumberOfRows, "字目"
	appendInfo: string$
endfor
appendInfoLine: ""
percent = numberOfRows / numberOfRowsAll * 100
percent$ = fixed$(percent, 2)
appendInfoLine: "共查询到", numberOfRows, "个汉字", "占", numberOfRowsAll, "个的", percent$, "%"






