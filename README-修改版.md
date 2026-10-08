<div align="center">
  <img src="assets/icon.png" width="120" alt="Praat 修改版图标" />
  <h1>Praat 修改版</h1>
  <p>电脑上的语音实验台</p>
  <p>
    <a href="https://github.com/Jeoitim/praat-chinese-modified/releases">下载与版本记录</a> ·
    <a href="https://github.com/Jeoitim/praat-chinese-modified/tree/jeoitim-modified">修改版源码</a> ·
    <a href="https://github.com/KasumiKitsune/praat-simplified-chinese/tree/modern">开发上游</a>
  </p>
</div>

Praat 修改版由 **jeoitim** 维护，直接 fork 自 **KasumiKitsune/praat-simplified-chinese** 的 `modern` 分支。在保留现代界面和汉化帮助手册的基础上，加入贝先明、向柠提供的汉化及自定义内容，调整术语、资源位置和作者署名。

当前基础版本为 Praat **7.0.02**，开发分支为 `jeoitim-modified`。目前已编译和验证的发行平台是 **Windows x64**。macOS、Linux 尚未完成本修改版的构建和功能验证。

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

这个项目面向习惯中文界面、需要自定义语音分析流程的 Praat 用户。它保留 KasumiKitsune 项目的完整现代界面，补入贝先明、向柠的汉化及自定义内容，并让脚本随程序加载，省去向 `C:\scrpt` 部署资源的步骤。

开发时只跟进 KasumiKitsune 的 `modern` 分支。Praat 原版保留为算法、构建资料和作者署名的来源，避免同时维护几套上游修改。

## 2. 修改内容

### 2.1 保留的上游功能

- 现代控件、对象列表右键菜单、顶部快捷按钮和文件拖拽打开。
- 播放与暂停、波形进度视图、声音编辑器中的独立操作按钮。
- 录音界面、多对象批量重命名、Python 脚本入口和界面语言设置。
- 汉化帮助手册、手册搜索和复制页面文本。

这些功能来自 KasumiKitsune 项目。本修改版保留相关实现，现代界面的主要绘制代码仍依赖 Windows Win32。

### 2.2 本修改版追加的内容

- 加入 92 个增强菜单和 86 份脚本，包括提供的原脚本和明确标注的补充脚本。
- 汉化术语以贝先明、向柠提供的内容为参考，再补充上游翻译；统一使用“语谱”“基频”等用语。
- 补齐图例、时间栏、窗口标题、退出确认、加载提示及常见分析提示的汉化。
- 将内置资源放在程序目录的 `assets/legacy`，将默认分析数据放在独立配置目录的 `data` 中。
- 修正隐藏兼容命令的菜单层级，避免“查询”等下拉菜单被摊开到右侧动作栏。
- 关于页按组件来源列出完整作者姓名，保留上游图标和中文标语，并修复鼠标移动导致页面关闭的问题。
- 随程序提供国际音标字体，按进程私有方式加载；修复当前 Windows 工具链的重复清单问题。

英文脚本命令名称及必要的旧命令别名继续保留，界面汉化不会把脚本源文件改写成另一套命令。

## 3. 内容来源与作者

| 组件或内容 | 作者 | 来源 |
| :--- | :--- | :--- |
| 修改版维护、内容补入与本项目调整 | jeoitim | [本仓库](https://github.com/Jeoitim/praat-chinese-modified) |
| 中文汉化及自定义内容 | 贝先明、向柠 | 提供的汉化参考源码与汉化修改版 5.2 安装包；脚本保留各自原署名 |
| 现代界面、播放器、快捷操作及汉化帮助手册 | KasumiKitsune 及项目贡献者 | [praat-simplified-chinese](https://github.com/KasumiKitsune/praat-simplified-chinese) |
| Praat 核心程序与原始算法 | Paul Boersma、David Weenink、Anastasia Shchupak 及各模块贡献者 | [Praat](https://github.com/praat/praat) / [praat.org](https://praat.org) |
| Doulos SIL 国际音标字体 | SIL International | 随参考安装包提供，许可见 [OFL.txt](assets/fonts/OFL.txt) |

关于页中的署名采用完整姓名，不用“贝版”“Kasumi 版”等简称替代共同作者。完整来源、补充实现的差异及第三方许可见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。

当前开发基线：KasumiKitsune `modern` 分支，提交 `39c8cf719f14264ede85465ec977cdb7bbc9f711`。

## 4. 下载与使用

1. 在 [Releases](https://github.com/Jeoitim/praat-chinese-modified/releases) 中选择本修改版发布的 Windows x64 压缩包。如果尚无发布条目，可使用已经提供的本地运行包。
2. 完整解压到自己可写的目录，运行 `PraatChineseModified.exe`。
3. 保留程序同级的 `assets`、字体、音视频和音量辅助工具。仅复制一个 exe 会缺少增强资源。

本版不需要运行旧安装包的 `setup.exe`，也不需要创建或复制文件到 `C:\scrpt`。`assets/docs` 中保留的原作者说明属于参考资料，本版的安装与目录规则以此 README 为准。

## 5. 资源与数据保存位置

### 5.1 默认位置

| 内容 | 保存位置 |
| :--- | :--- |
| 内置增强脚本与参考表格 | 程序目录下的 `assets/legacy` |
| 初始数据模板、字体和关于页 | 程序目录下的 `assets/data`、`assets/fonts`、`assets/about.html` |
| 配置与默认分析数据 | Windows 默认配置目录 `C:\Users\你的用户名\AppData\Roaming\PraatChineseModified`，分析数据位于其中的 `data` |
| 用户指定的导出结果 | 相应对话框或脚本参数指定的目录 |

配置目录可以通过 Praat 的 `--pref-dir` 参数指定。初始数据模板只复制到尚不存在的文件，不覆盖已有数据。

### 5.2 “不使用 C:\scrpt”具体指什么

程序从自己的资源目录加载内置脚本，不向 `C:\scrpt` 安装、复制或更新它们。已有的 `C:\scrpt` 不会被自动删除，也不会被自动迁移。

正常使用仍会产生配置和结果文件。大部分分析脚本默认写入配置目录的 `data`；用户选择的导出结果保存在指定位置。部分原有屏幕或摄像头录制工具还会在程序目录生成临时批处理文件，因此建议将程序解压到可写位置。

“运行前后 C:\scrpt 未被改动”是本次兼容测试的验证结果，不表示程序完全不写文件，也不表示每个旧脚本的每种分支都已逐项测试。

## 6. 已知限制

- 原参考安装包及已有脚本目录均缺少 `by.praat` 和 `bz.praat`。补充版本分别绘制明确标注的声调示意，以及根据用户提供的 V 值表绘制元音图，不能视为缺失原脚本的等价复刻。
- 部分旧 `H` / `Bei` 命令没有提供原始实现源码。本版用当前分析 API 重建兼容，并核对已有程序的数值输出。分析算法采用当前版本，结果可能与较早版本不同。
- 需要实际音频素材、麦克风、摄像头或第三方程序的功能，尚未逐项人工验证。
- 部分增强脚本仍含 Windows 路径、批处理命令、`.exe` 工具和 Windows 图元文件输出，不能直接当成跨平台脚本使用。

## 7. 编译与平台支持

### 7.1 Windows x64

安装 MinGW-w64 GCC（含 `mingw32-make`）和 Git for Windows，在项目目录运行：

```powershell
.\build-windows.ps1
```

输出位于 `dist/PraatChineseModified-7.0.02-modern`。构建脚本打包增强资源、字体、许可和辅助工具，并针对当前工具链处理 Windows 清单。编译前应关闭正在使用同一输出文件的程序。

### 7.2 其他平台

Praat 核心和大部分汉化代码有跨平台基础，但本修改版目前只验证了 Windows x64。

| 平台 | 当前判断 | 还需要处理的内容 |
| :--- | :--- | :--- |
| Windows x64 | 已构建并验证 | 继续补充实际素材和设备测试 |
| Linux | 可以推进核心与 GTK 界面构建，尚未验证 | 资源定位、关于页打开方式、字体加载、脚本路径和外部工具 |
| macOS | 有上游构建基础，尚未验证 | Xcode 工程加入新模块、`.app` 资源打包、字体与关于页处理、脚本适配；公开分发时还需处理签名和公证 |

Windows 上的现代控件代码不能原样移到 Cocoa 或 GTK。如果要求其他平台也呈现同样的界面，还需要单独实现对应控件。通用构建资料见 [HOW_TO_BUILD_ONE.md](https://github.com/Jeoitim/praat-chinese-modified/blob/jeoitim-modified/HOW_TO_BUILD_ONE.md)，本修改版的具体差异见 [开发与发布指南](docs/maintenance-and-release.zh.md)。

## 8. 版本发布与上游同步

修改版 tag 建议采用 `v7.0.02-jeoitim.1`，保留 Praat 基础版本并增加本项目修订号。同一基础版本的后续修改递增为 `.2`、`.3`；候选版可使用 `v7.0.02-jeoitim.1-rc.1`。

`modern` 分支用于保留上游镜像，`jeoitim-modified` 用于本项目开发。上游更新先进入独立同步分支，解决冲突、编译并测试后再合入修改分支。发布 tag 固定到经过验证的提交，已经发布的 tag 不再移动。

继承的 `.github/workflows/release.yml` 尚未适配本修改版的完整资源包。当前不要直接用它发布，具体 tag、完整打包、草稿 Release 和上游同步步骤见 [开发与发布指南](docs/maintenance-and-release.zh.md)。

## 9. 许可

Praat 与本修改版按 GPL-3.0-or-later 分发。源码中的原作者署名继续保留，字体和第三方工具遵循各自许可。见 [GPL](gpl-3.0.txt)、[第三方说明](THIRD_PARTY_NOTICES.md) 和 [字体许可](assets/fonts/OFL.txt)。
