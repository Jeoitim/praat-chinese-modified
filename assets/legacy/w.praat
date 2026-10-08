legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是播放视频。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.05.21

form set parameters
sentence 注意： 1.先设置播放的画面大小（x、y）
sentence 注意： 2.再点击“确定”选择文件
sentence 注意： 3.播放完毕点击任意键退出
positive x 1600
positive y 900
endform

fileName$ = chooseReadFile$: "请选择需要播放的视频文件"
if fileName$ != ""
	system 'applicationDirectory$'\ffplay.exe -showmode 0 -stats -x 'x' -y 'y' -exitonkeydown "'fileName$'"
endif