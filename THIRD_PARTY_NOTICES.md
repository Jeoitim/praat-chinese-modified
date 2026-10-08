# 来源与署名

- 官方 Praat v7.0.02，commit 6f3da9ef1d8cce0d5684afc104d02888dfc71b25。Paul Boersma、David Weenink、Anastasia Shchupak 及原仓库各文件署名的贡献者。https://github.com/praat/praat
- 中文汉化及自定义内容：贝先明、向柠，来自公众号“实验语音学与praat软件”提供的源码和安装包（本次最新参考安装包为汉化修改版 6.0，早期移植曾参考 5.2）；保留每个脚本的原署名。http://blog.sina.com.cn/xianmingbei
- 中文词典和现代 Windows 控件绘制：KasumiKitsune/praat-simplified-chinese 及其贡献者；master 2b70d22c6da8b750049ec81cd58e41184692205b，modern 39c8cf719f14264ede85465ec977cdb7bbc9f711. https://github.com/KasumiKitsune/praat-simplified-chinese

本项目按 Praat 的 GPL-3.0-or-later 条款分发。第三方外部库的许可保留在各原目录中；视频及音量辅助程序保留原安装包内容，不修改二进制。

参考源码标记为 7.0beta，未提供安装版 H 测量命令的源码。本项目按脚本使用的输出格式用 v7.0.02 的 Pitch/Formant API 补齐；9 个基频点含选区两端（与提供的 PitchEditor 测量脚本一致），10 点共振峰含选区两端。数值使用当前版本的分析算法，可能与旧版不同。

## 原资源缺失与兼容重建

原安装包的 Buttons5.ini 引用了不存在的 `by.praat` 和 `bz.praat`，C:\scrpt 也没有它们。补充版 by 绘制五度制声调示意（明确非实测 T 值），bz 使用用户选定的 V 值表。旧版 H 测量与 Bei 数值命令源码亦未提供；幅度、频谱功率、能量分布、偏度、峰度、标准误、Jarque–Bera 已通过旧版可执行程序的测试结果核对。绘图辅助语句和视频处理脚本用原版脚本 API 重写。

官方 v7.0.02 缺失 external/zlib/zconf.h；补齐文件取自 madler/zlib 官方仓库 commit 767c4c947852e143f582c85f14cf573411df1b35.

Doulos SIL 4.110 字体：SIL International，按 SIL Open Font License 1.1 原样分发，许可见 assets/fonts/OFL.txt；以 FR_PRIVATE 为本进程加载，不安装到系统。

## 当前唯一上游

新项目直接 fork KasumiKitsune/praat-simplified-chinese，完整基于 modern 分支 commit 39c8cf719f14264ede85465ec977cdb7bbc9f711；保留其现代界面、右键菜单、播放器、编辑器快捷按钮和汉化帮助手册。Jeoitim 的修改仓库为 https://github.com/Jeoitim/praat-chinese-modified 。本修改版作者署名：jeoitim。

## 公众号 6.0 参考包与跨平台适配

参考来源：贝先明、向柠的汉化及自定义内容，来自公众号“实验语音学与praat软件”提供的源码和安装包。本轮按提供的汉化修改版 6.0 安装程序核对资源，原脚本的作者注释保留；安装包和原脚本校验记录见 `assets/legacy/reference-6.0.json`。

新增 dl（绝对时长 T 值平均）、do（音韵条件检索）、dr（字符提取）、ds（字频）及词频脚本，更新 14 份原脚本与配套资料。by、bz 在 6.0 包中仍缺失，沿用明确标注的补充实现。

跨平台路径、PNG/PDF 导出、文件操作、外部工具适配由 jeoitim 修改。录像改为按设定时长录制；设备后端使用 FFmpeg 的 DirectShow/gdigrab、AVFoundation、X11/V4L2/PulseAudio。Wayland 原生屏幕捕获及 macOS 系统音频回环不伪装为通用功能，需要系统录屏或相应音频设备。

原包的独立 Windows 分词/词性/词云工具保留于 Windows 辅助工具中。跨平台版本按原工作流重新实现，依赖用户安装的 jieba（MIT）、wordcloud（MIT）、Pillow（HPND）；这些库不随本项目内置。分词结果可能与原工具版本不同。

检查中修复 cd/cg/d/v 原脚本的控制结构问题、ax 的重复计数及 dr/ds 对带空格文件名的输出定位问题。两项缺失的 Table 命令改用标准 log10 / hertzToBark 公式，不声称复刻未提供的原生实现源码。
