<div align="center">
  <img src="docs/pictures/icon.png" width="120" alt="Praat 修改版图标" />
  <h1>Praat 修改版</h1>
  <p>电脑上的语音实验台</p>
  <p>
    <a href="https://github.com/Jeoitim/praat-chinese-modified/releases">下载与版本记录</a> ·
    <a href="https://github.com/Jeoitim/praat-chinese-modified/tree/jeoitim-modified">修改版源码</a> ·
    <a href="https://github.com/KasumiKitsune/praat-simplified-chinese/tree/modern">开发上游</a>
  </p>
</div>

Praat 修改版由 **jeoitim** 维护，直接 fork 自 **KasumiKitsune/praat-simplified-chinese** 的 `modern` 分支。在保留现代界面和汉化帮助手册的基础上，加入贝先明、向柠提供的汉化及自定义内容，调整术语、资源位置和作者署名。这些汉化及自定义内容来自公众号“实验语音学与praat软件”提供的源码和安装包。

当前基础版本为 Praat **7.0.02**，开发分支为 `jeoitim-modified`。项目提供 **Windows x64、Linux x64、macOS 通用应用**的构建和完整资源打包流程。平台验证范围与设备限制见 [跨平台指南](docs/cross-platform.zh.md)。

## 目录

- [1. 项目目标](#1-项目目标)
- [2. 修改内容](#2-修改内容)
- [3. 内容来源与作者](#3-内容来源与作者)
- [4. 下载与使用](#4-下载与使用)
- [5. 资源与数据保存位置](#5-资源与数据保存位置)
- [6. 已知限制](#6-已知限制)
- [7. 编译与平台支持](#7-编译与平台支持)
- [8. 版本发布与上游同步](#8-版本发布与上游同步)
- [9. 许可](#9-许可)

## 1. 项目目标

这个项目面向习惯中文界面、需要自定义语音分析流程的 Praat 用户。它保留 KasumiKitsune 项目的完整现代界面，补入贝先明、向柠的汉化及自定义内容，并让脚本随程序加载，省去公众号参考安装包向 `C:\scrpt` 部署资源的步骤。

开发时只跟进 KasumiKitsune 的 `modern` 分支。Praat 原版保留为算法、构建资料和作者署名的来源，避免同时维护几套上游修改。

## 2. 修改内容

### 2.1 保留的上游功能

- 现代控件、对象列表右键菜单、顶部快捷按钮和文件拖拽打开。
- 播放与暂停、波形进度视图、声音编辑器中的独立操作按钮。
- 录音界面、多对象批量重命名、Python 脚本入口和界面语言设置。
- 汉化帮助手册、手册搜索和复制页面文本。

这些功能来自 KasumiKitsune 项目。本修改版保留相关实现，现代界面的主要绘制代码仍依赖 Windows Win32。

### 2.2 本修改版追加的内容

- 加入 97 个增强菜单，随包提供 91 份增强脚本。
- 汉化术语以贝先明、向柠提供的内容为参考，再补充上游翻译；统一使用“语谱”“基频”等用语。
- 补齐图例、时间栏、窗口标题、退出确认、加载提示及常见分析提示的汉化。
- 将内置资源放在程序目录的 `assets/legacy`，将默认分析数据和配置分别放在程序旁的 `data`、`settings` 中。
- 修正隐藏兼容命令的菜单层级，避免“查询”等下拉菜单被摊开到右侧动作栏。
- 关于页按组件来源列出完整作者姓名，保留上游图标和中文标语，并修复鼠标移动导致页面关闭的问题。
- 随程序提供国际音标字体，按进程私有方式加载；修复当前 Windows 工具链的重复清单问题。

英文脚本命令名称及必要的旧命令别名继续保留，界面汉化不会把脚本源文件改写成另一套命令。

## 3. 内容来源与作者

| 组件或内容 | 作者 | 来源 |
| :--- | :--- | :--- |
| 修改版维护、内容补入与本项目调整 | jeoitim | [本仓库](https://github.com/Jeoitim/praat-chinese-modified) |
| 中文汉化及自定义内容 | 贝先明、向柠 | 公众号“实验语音学与praat软件”提供的源码和安装包；本次参考安装包为汉化修改版 6.0，脚本保留各自原署名 |
| 现代界面、播放器、快捷操作及汉化帮助手册 | KasumiKitsune 及项目贡献者 | [praat-simplified-chinese](https://github.com/KasumiKitsune/praat-simplified-chinese) |
| Praat 核心程序与原始算法 | Paul Boersma、David Weenink、Anastasia Shchupak 及各模块贡献者 | [Praat](https://github.com/praat/praat) / [praat.org](https://praat.org) |
| Doulos SIL 国际音标字体 | SIL International | 随参考安装包提供，许可见 [OFL.txt](assets/fonts/OFL.txt) |

完整来源、补充实现的差异及第三方许可见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。

当前开发基线：KasumiKitsune `modern` 分支，提交 `39c8cf719f14264ede85465ec977cdb7bbc9f711`。

## 4. 下载与使用

1. 在 [Releases](https://github.com/Jeoitim/praat-chinese-modified/releases) 中选择对应系统的完整包。尚未正式发布的平台，可从 Actions 获取测试产物或自行构建。
2. Windows 运行 `PraatChineseModified.exe`，Linux 运行 `PraatChineseModified`，macOS 打开完整 `.app`。
3. 保留随包资源。Windows 和 Linux 的 `assets` 位于程序旁，macOS 的资源位于应用包内；外部工具依赖见跨平台指南。

本版不需要运行旧安装包的 `setup.exe`，也不需要创建或复制文件到 `C:\scrpt`。`assets/docs` 中保留的原作者说明属于参考资料，本版的安装与目录规则以此 README 为准。

## 5. 资源与数据保存位置

### 5.1 默认位置

| 内容 | 保存位置 |
| :--- | :--- |
| 内置增强脚本与参考表格 | 程序目录下的 `assets/legacy` |
| 初始数据模板、字体和关于页 | 程序目录下的 `assets/data`、`assets/fonts`、`assets/about.html` |
| Windows、Linux 配置与分析结果 | 可执行程序旁的 `settings`、`data` |
| macOS 配置与分析结果 | `.app` 所在目录的 `settings`、`data`，不写入应用包 |
| 用户指定的导出结果 | 相应对话框或脚本参数指定的目录 |

默认采用便携配置，不读取或迁移旧版用户配置。请将完整程序放在可写目录；目录不可写时会提示错误，不会改存到用户目录。需要另存配置时，可以显式使用 `--pref-dir=<目录>`。初始数据模板只复制到尚不存在的文件，不覆盖已有数据。

### 5.2 “不使用 C:\scrpt”具体指什么

这里指的是公众号“实验语音学与praat软件”提供的参考安装包的资源部署方式：本次参考的汉化修改版 6.0 通过安装脚本，将自定义脚本和配套文件复制到 `C:\scrpt`。

本修改版改为从程序自身的资源目录加载这些内置脚本，不再向 `C:\scrpt` 安装、复制或更新它们。已有的 `C:\scrpt` 不会被自动删除，也不会被自动迁移。

正常使用仍会产生配置和结果文件。分析脚本默认写入程序旁的 `data`；用户选择的导出结果保存在指定位置。录像适配按选择的路径保存结果，本进程及配套 Python 工具的临时文件和缓存使用 `data/.tmp`、`data/.cache`，不再生成旧版批处理文件。

“运行前后 C:\scrpt 未被改动”是本次兼容测试的验证结果，不表示程序完全不写文件，也不表示每个旧脚本的每种分支都已逐项测试。

## 6. 已知限制

- 部分旧 `H` / `Bei` 命令没有提供原始实现源码。本版用当前分析 API 重建兼容，并核对已有程序的数值输出。分析算法采用当前版本，结果可能与较早版本不同。
- 需要实际音频素材、麦克风、摄像头或第三方程序的功能，尚未逐项人工验证。
- 增强脚本已完成路径、文件操作、图形导出和外部工具的平台适配。录像、系统音量、应用启动和自动分词另需 Python 或系统工具；可用性取决于设备后端、权限及所安装的依赖。

## 7. 编译与平台支持

### 7.1 Windows x64

安装 MinGW-w64 GCC（含 `mingw32-make`）和 Git for Windows，在项目目录运行：

```powershell
.\build-windows.ps1
```

输出位于 `dist/PraatChineseModified-7.0.02-modified`。构建脚本打包增强资源、字体、许可和辅助工具，并针对当前工具链处理 Windows 清单。编译前应关闭正在使用同一输出文件的程序。

### 7.2 Linux 与 macOS

Linux 使用 GTK 与系统音频库，运行 `bash build-linux.sh`；macOS 使用对应版本的官方 Xcode 工程，运行 `bash build-macos.sh`，生成包含全部资源的通用 `.app`。依赖安装、架构选择、签名以及脚本使用方式见 [跨平台指南](docs/cross-platform.zh.md)。

Windows 的现代控件来自上游 Win32 实现，其他平台使用 GTK 或 Cocoa 控件。分析功能和汉化手册共用源码，界面外观随平台有所不同。

## 8. 版本发布与上游同步

发行版本使用 Praat 基础版本和修改版修订号标记，例如 `v7.0.02-jeoitim.1`。同一基础版本的后续修订递增为 `.2`、`.3`，候选版带有 `-rc.1` 等后缀。用户可在 [Releases](https://github.com/Jeoitim/praat-chinese-modified/releases) 下载对应平台的完整包；脚本、字体及其他资源应随程序一起保留。

贡献者以 `jeoitim-modified` 为开发基线提交修改。`modern` 分支保留 KasumiKitsune 上游代码，上游更新经独立同步分支处理冲突、构建和测试后合入。已发布的 tag 固定到对应源码，不移动或覆盖。

自动构建会检查 Windows、Linux 与 macOS 并提供测试产物。发布流程从已有 tag 构建完整资源包，先生成草稿 Release，检查后再公开。构建产物和候选版便于测试，不等同于已经完成设备验证的正式版本。维护与贡献步骤见 [开发与发布指南](docs/maintenance-and-release.zh.md)。

## 9. 许可

Praat 与本修改版按 GPL-3.0-or-later 分发。源码中的原作者署名继续保留，字体和第三方工具遵循各自许可。见 [GPL](main/gpl-3.0.txt)、[第三方说明](THIRD_PARTY_NOTICES.md) 和 [字体许可](assets/fonts/OFL.txt)。
