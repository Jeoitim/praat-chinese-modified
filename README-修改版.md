# Praat 修改版

作者 **jeoitim**。直接 fork [KasumiKitsune/praat-simplified-chinese](https://github.com/KasumiKitsune/praat-simplified-chinese)，以 **modern** 分支为唯一开发上游。

完整保留 KasumiKitsune 的现代控件、右键菜单、播放/暂停及波形进度视图、快捷按钮、录音界面、语言切换和汉化帮助手册。汉化术语以贝先明、向柠提供的内容为准，再补充 KasumiKitsune 内容，统一使用“语谱”。

补充贝先明、向柠提供的内容的 92 个增强菜单和脚本，显示 Ⓑ、Ⓗ 标记并保留旧脚本命令。资源位于程序 assets/legacy，数据在独立的偏好设置目录 data 中；不向 C:\scrpt 复制或写入。程序支持中文与空格路径，移动位置后自动重建内置菜单。

提供清晰的原生关于卡片和离线 HTML 详情，署名包含 jeoitim、贝先明、向柠、KasumiKitsune 及原 Praat 作者。国际音标字体私有加载，不安装到系统。

## 编译与运行

运行 build-windows.ps1，输出 dist/PraatChineseModified-7.0.02-modern。保留 exe 同级的 assets 与辅助程序。Git 的 origin 指向 Jeoitim/praat-chinese-modified，upstream 指向 KasumiKitsune/praat-simplified-chinese。

旧目录已完整备份为 praat-chinese-modified-backup-20261008，新目录为全新 fork 克隆，不再使用旧移植版本为基础。

## 原参考资源限制

原安装包缺少 by.praat、bz.praat，提供了明确标注的补充版本。H/Bei 的部分原始实现源码缺失，以现有算法和原程序测试结果重建兼容。具体差异及各项许可见 THIRD_PARTY_NOTICES.md。

本项目按 GPL-3.0-or-later 分发，保留所有第三方署名与独立许可。
