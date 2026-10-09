# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是根据赫兹求临界频带值。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.11.03

form set parameters
	real hertz 0
endform
if hertz < 0
	exit hertz必须大于等于0
endif
clearinfo
band = hertzToBark(hertz)
printline 'hertz'所在的频率区间是：'band:0'
