# Praat 修改版 v7.0.02-jeoitim.1

首个正式修改版发布，基于 KasumiKitsune/praat-simplified-chinese 的 `modern` 分支，Praat 核心版本为 7.0.02。提供 Windows x64、Linux x64 和 macOS arm64/x86_64 通用应用的完整资源包。

## 修改内容

- 保留上游现代界面、对象列表右键菜单、播放器视图、快捷按钮及汉化帮助手册。Windows 使用上游现代控件，Linux 和 macOS 使用 GTK、Cocoa 界面。
- 补入贝先明、向柠的汉化及自定义内容，来自公众号“实验语音学与praat软件”提供的源码和安装包；核对 6.0 安装包后新增 5 份、更新 14 份脚本，共提供 97 个增强菜单和 91 份脚本。
- 补齐常见提示、图例、时间栏和退出确认的汉化，统一“语谱”“基频”等术语，修复右侧菜单分组及关于页自动关闭问题。
- 使用上游 README 图标，关于页保留“电脑上的语音实验台”，按组件署名作者。
- 脚本改用跨平台路径、文件操作和 PNG/PDF 导出；媒体操作通过参数列表调用 FFmpeg。新增平台资源定位、私有字体加载、分词词性统计和词云适配。
- 修复原脚本的控制结构、重复计数及带空格文件名可能覆盖输入的问题。资源随程序加载，不运行旧安装程序，也不向 `C:\scrpt` 部署脚本。

## 下载与使用

| 附件 | 用途 |
| :--- | :--- |
| Windows-x64.zip | 完整解压后运行 PraatChineseModified.exe，保留 assets 和辅助工具 |
| Linux-x64.tar.gz | 在 Ubuntu 24.04 构建；运行 PraatChineseModified，目标系统需兼容的 GTK 3、音频库和 C++ 运行库 |
| macOS-universal.zip | 解压后打开完整 .app，包含 arm64 与 x86_64 架构 |
| source.zip | 与此 tag 对应的完整源码及资源 |
| SHA256SUMS.txt | 附件 SHA-256 校验值 |

Python、FFmpeg、录音录像设备和字体要求见随包跨平台指南。基础语音分析不需要 Python。默认配置和分析数据保存在各平台独立的修改版配置目录，导出结果保存在所选择的位置。

## 验证与已知限制

三平台在此发布 tag 上重新构建并运行测试。全部 91 份脚本通过平台依赖和控制结构检查；兼容数值、音频读写、基频分析、字符提取、字频、音韵条件检索、相对/绝对时长 T 值平均图、PNG/PDF 导出及中文空格路径的媒体转换通过样本验证。分词、词性统计和中文词云另已用实际 Python 依赖验证。

- 麦克风、摄像头、系统回环音源和屏幕录制尚未逐设备验证。Linux 原生 Wayland 屏幕捕获需使用系统录屏工具；macOS 系统声音需相应回环音频设备。
- macOS 包为临时签名，尚未使用 Developer ID 签名和公证。Windows 程序未附带发行者代码签名。
- 部分旧 H/Bei 原生实现源码未提供，兼容重建及差异见 THIRD_PARTY_NOTICES.md。

## 内容来源与作者

- 修改版维护与平台适配：jeoitim。
- 汉化及自定义内容：贝先明、向柠，来源为公众号“实验语音学与praat软件”提供的源码和安装包；保留各脚本原署名。
- 现代界面与汉化手册：KasumiKitsune 及项目贡献者。
- Praat 核心：Paul Boersma、David Weenink、Anastasia Shchupak 及各模块贡献者。

源码按 GPL-3.0-or-later 分发，字体及第三方工具许可随包提供。
