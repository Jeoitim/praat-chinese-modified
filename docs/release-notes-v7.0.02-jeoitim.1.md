# Praat 修改版 v7.0.02-jeoitim.1

基于 KasumiKitsune/praat-simplified-chinese 的 modern 分支，Praat 基础版本为 7.0.02。本次发布 Windows x64 修改版。

## 修改内容

- 保留现代界面、右键菜单、播放器、快捷按钮和汉化帮助手册。
- 加入贝先明、向柠提供的汉化及自定义内容，统一术语并补齐常用提示翻译。
- 内置脚本从程序资源目录加载，不再部署到 C:\scrpt；默认分析数据使用独立配置目录。
- 修复菜单分组与关于页自动关闭问题，按组件完整署名作者，并采用上游原图标和中文标语。
- 处理 Windows 高 DPI 清单冲突，随程序私有加载国际音标字体。

## 使用方法

完整解压 Windows x64 压缩包，运行 PraatChineseModified.exe。保留同级 assets 和辅助工具，不需要旧 setup.exe。

## 验证与限制

Windows x64 构建、旧数值命令兼容、音频读写与分析、常见提示汉化已通过检查。部分 GUI 和手册功能已实际检查；需要设备或特定素材的全部旧脚本尚未逐项验证。发布前应补充维护者自己的常用素材测试记录。

原参考包缺少 by.praat 与 bz.praat，提供了明确标注的补充版本。部分旧命令源码缺失，以当前 API 和原程序结果重建兼容，详见 THIRD_PARTY_NOTICES.md。macOS 和 Linux 尚未发布验证版。

## 内容来源

修改版维护：jeoitim。中文汉化及自定义内容：贝先明、向柠。现代界面与中文手册：KasumiKitsune 及项目贡献者。Praat 核心：Paul Boersma、David Weenink、Anastasia Shchupak 及各模块贡献者。

源码与许可随发布提供，附件 SHA-256 见 SHA256SUMS.txt。
