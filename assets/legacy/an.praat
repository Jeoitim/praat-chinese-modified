# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
form set parameters
	positive herzt 100
	positive reference_frequency 50
endform
clearinfo
semitone = Bei 根据赫兹按指定参考频率求半音... herzt reference_frequency
printline 'semitone'