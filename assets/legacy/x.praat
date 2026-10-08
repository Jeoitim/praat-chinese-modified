legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = preferencesDirectory$ + "/data"
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是截取视频。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.05.21

form set parameters
comment 注意： 文件名不能包含空格。
sentence file_path d:\praat修改版
sentence fileName myvideo
sentence fileType mp4
sentence timeStart 00:00:01
sentence timeEnd 00:00:03
endform
system 'applicationDirectory$'\ffmpeg.exe -y -i "'file_path$'"\'fileName$'.'fileType$' -ss 'timeStart$' -to 'timeEnd$' -intra "'file_path$'"\new'fileName$'.'fileType$'
exit 截取视频完成。
