legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是绘制频谱图（带临界坐标刻度）。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.11.03

fileName$ = selected$("Spectrum");判断是否有Spectrum文件被选定。
lowestFrequency = Get lowest frequency
highestFrequency = Get highest frequency
if highestFrequency > 10010
	highestFrequency = 10010
endif
hertzMin = 0
hertzMax = 10010
numberOfBins = Get number of bins
dBMin = 999999999
dBMax = -999999999
for i from 1 to numberOfBins
	dB = Bei 功率谱分贝值... i
	if dBMin > dB
		dBMin = dB
	endif
	if dBMax < dB
		dBMax = dB
	endif
endfor
if lowestFrequency >= hertzMax
	exit 此频谱图涉及的频率范围不在0~10010Hz之间，无法画图。
elsif lowestFrequency < hertzMax and highestFrequency > hertzMin
	bandMin = hertzToBark(lowestFrequency)
	bandMax = hertzToBark(highestFrequency)
	bandMin = floor(bandMin)
	bandMax = ceiling(bandMax)
	if bandMax = 25
		bandMax = 24
	endif
		Erase all
		Draw inner box
		Axes... 'lowestFrequency' 'highestFrequency' 'dBMin' 'dBMax'
		Red
		Draw... 'lowestFrequency' 'highestFrequency' 'dBMin' 'dBMax' yes
		temp = ceiling(highestFrequency / 1000)
		for j from 1 to temp
			z = 1000 * j
			if z != 10000 and z != 11000
				One mark bottom... 'z' no yes no 'z'
			endif
		endfor
		Text top... yes %Critical band
		for k from bandMin to bandMax
			if k mod 2 = 0 and k != 0 and k != 2
				One mark top... barkToHertz(k) no yes yes 'k'
			elsif k mod 2 != 0 and k != 1 and k != 3 and k != 5 and k != 7 and k != 9
				One mark top... barkToHertz(k) no yes yes 
			endif
		endfor
		Black
endif

