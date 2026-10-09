# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
form set parameters
	positive semitone 100
	positive reference_frequency 50
endform
clearinfo
herzt = Bei 根据半音按指定参考频率求赫兹... semitone reference_frequency
printline 'herzt'