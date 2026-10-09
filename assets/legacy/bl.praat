# 修改：jeoitim（Praat 修改版）。
# 已进行跨平台、便携路径或兼容性适配，与参考安装包中的原始脚本有差异；保留原作者署名。
legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
form set parameters
	positive silence_threshold 0.01
	positive voicing_threshold 0.25
	positive minimum_pitch 85
	choice type 3
	button for_irregular1
	button for_irregular2
	button for_regular
	sentence 注意 基频曲线异常，请选for_irregular
	sentence 注意 测量完该音节，请选for_regular复原参数
endform
if type = 1
	Advanced pitch settings... 0 0 no 15 'silence_threshold' 'voicing_threshold' 0.01 0.35 0.14
	Pitch settings... 75 500 Hertz cross-correlation automatic
elsif type = 2
	Advanced pitch settings... 0 0 no 15 0.01 0.25 0.01 0.35 0.14
	Pitch settings... 'minimum_pitch' 500 Hertz cross-correlation automatic
elsif type = 3
	Advanced pitch settings... 0 0 no 15 0.03 0.45 0.01 0.35 0.14
	Pitch settings... 75 500 Hertz cross-correlation automatic
endif