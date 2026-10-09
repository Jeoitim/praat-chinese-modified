# 跨平台构建与增强脚本

本项目以 KasumiKitsune 的 `modern` 分支为唯一开发上游。Praat 核心、汉化手册和增强分析脚本面向 Windows、Linux 与 macOS；上游的 Windows 现代控件仍使用 Win32 实现，Linux 与 macOS 使用各自的 GTK、Cocoa 界面。

## 1. 构建与验证范围

项目提供三个平台的构建入口，以及 GitHub Actions 构建和资源打包流程。能编译不等于每一种设备或语料都已验证：麦克风、摄像头、系统回环音源和图形桌面仍需在实际设备上测试。

| 平台 | 构建入口 | 运行资源 |
| :--- | :--- | :--- |
| Windows x64 | `build-windows.ps1` | 可执行文件旁的 `assets` 与 Windows 辅助工具 |
| Linux x64 | `bash build-linux.sh` | 可执行文件旁的 `assets`；FFmpeg 等工具从系统 PATH 查找 |
| macOS arm64 / x86_64 | `bash build-macos.sh` | `.app/Contents/Resources/assets`，FFmpeg 等工具从系统 PATH 查找 |

程序按可执行文件位置查找资源，不依赖启动时的工作目录。Linux 安装到 `bin` 时，也可使用同一前缀下的 `share/PraatChineseModified/assets`。特殊安装可将 `PRAAT_MODIFIED_RESOURCES` 设置为包含 `assets/legacy` 的绝对目录。

`applicationDirectory$` 表示修改版资源根目录；macOS 下是应用包的 Resources 目录。`dataDirectory$` 为便携分析数据目录：Windows、Linux 使用可执行程序旁的 `data`，macOS 使用 `.app` 所在目录的 `data`。配置默认写入同级 `settings`；临时文件和缓存写入 `data/.tmp`、`data/.cache`。目录不可写时会报错，不回退到用户目录。`--pref-dir=<目录>` 仅覆盖显式指定的配置位置。

## 2. Windows

准备 MinGW-w64 GCC、`mingw32-make` 与 Git for Windows，然后在项目目录运行：

```powershell
.\build-windows.ps1
```

可用 `-Jobs 4` 调整并行数量，或用 `-PackageDirectory` 指定新输出目录。可执行文件先生成到 `build`，完整包默认位于 `dist/PraatChineseModified-7.0.02-modified`。保留整包资源后运行 `PraatChineseModified.exe`。

CI 使用 MSYS2 CLANG64 的工具链，并以 `x64v1` 为目标。修改版不使用原参考安装包的 `setup.exe`，也不向 `C:\scrpt` 部署脚本。

## 3. Linux

Debian / Ubuntu 的依赖示例：

```bash
sudo apt-get update
sudo apt-get install build-essential pkg-config python3 libgtk-3-dev \
  libasound2-dev libpulse-dev libjack-jackd2-dev libfontconfig1-dev ffmpeg xdg-utils
bash build-linux.sh
```

Arch Linux 的依赖示例：

```bash
sudo pacman -Syu --needed base-devel pkgconf python gtk3 alsa-lib libpulse jack2 fontconfig ffmpeg xdg-utils
bash build-linux.sh
```

脚本默认使用 4 个编译任务，`JOBS=2 bash build-linux.sh` 可降低内存占用。跨架构构建需使用对应工具链，并调整 `PRAAT_ARCH`；不要混用不同平台、架构或编译参数产生的 `.o` 文件，建议使用独立源码检出目录。

解压完整 Linux 包，直接运行 `./PraatChineseModified`。GTK 和系统音频库仍需由目标系统提供；这不是将所有系统库静态打包的发行格式。对外分发宜使用较旧的受支持发行版构建，并在目标发行版上检查依赖。

## 4. macOS

准备支持当前 Praat 源码的 Xcode、命令行工具与 Python 3。媒体功能还需 FFmpeg；可使用系统包管理器安装。

```bash
xcode-select -p
python3 --version
bash build-macos.sh
```

构建脚本从 Praat 官方发行库获取与 `main/main_Praat.h` 版本一致的 Xcode 工程。7.0.02 模板有校验和检查。适配工具将汉化、Python、设置窗口和本项目新增模块加入源码编译阶段，使用 C++17，再构建 arm64 与 x86_64 通用应用。

只构建当前架构时可设置：

```bash
PRAAT_MAC_ARCHS=arm64 JOBS=4 bash build-macos.sh
```

完整 `.app` 包含脚本、字体、图标、关于页及许可。资源打包和 Info.plist 更新完成后，脚本进行本机临时签名。公开分发应使用维护者自己的 Developer ID 完成签名、公证和装订；临时签名不等同于经过公证的正式发行包。不要沿用 Praat 原作者的签名身份。

## 5. 全部增强脚本的适配范围

本次参考公众号“实验语音学与praat软件”提供的汉化修改版 6.0 安装包。随包提供 91 份增强脚本。逐文件适配记录见 [script-platforms.json](../assets/legacy/script-platforms.json)，6.0 原文件校验记录见 [reference-6.0.json](../assets/legacy/reference-6.0.json)。

- 所有脚本的文件路径改用 `/`；国际音标的反斜杠转义保留。
- 绘图脚本在 Windows 导出 600 dpi PNG，在 Linux / macOS 导出 PDF，代替固定使用 Windows 专用 EMF。原来以 `.xls` 命名的表格仍为制表符分隔文本，可用表格软件导入。
- 目录创建与撤销数据操作改用 Praat 自身的文件函数，不调用 `md`、`del` 或批处理。
- 调查表录音在各平台写入便携数据目录的 `data/sound`。
- 转码、截取、音频提取和去除音轨通过参数列表调用 FFmpeg，支持包含空格、中文和 shell 特殊字符的路径，不拼接 shell 命令。
- 文件夹、文件和关于页分别使用 Windows ShellExecute、macOS `open`、Linux `xdg-open`。

这些适配保留分析脚本的原算法与署名。需要编辑器选区、输入表、互动对话框或设备的脚本，必须用适当数据和环境运行；静态检查不能证明这些工作流全部正确。

## 6. 可选外部工具

### 6.1 Python、分词与词云

修改版继承上游的 Python 路径设置。媒体录制、系统音量、常用程序启动和自动分词适配使用该路径；默认 Windows 为 `python`，其他平台为 `python3`。这些功能需要用户安装 Python 3，并在设置中指定可执行程序。基础语音分析、绘图及普通 FFmpeg 转码不需要 Python。

自动分词与词性标注采用 jieba，词云采用 wordcloud 与 Pillow：

```bash
python3 -m pip install jieba wordcloud Pillow
```

Windows 可将命令中的 `python3` 换为已配置的 Python。词云还需指定支持中文的字体；随包 Doulos SIL 是国际音标字体。本项目按原词频工作流重新实现跨平台版本，不能将其视为原 Windows 分词工具的源码移植。原安装包的独立 Windows 工具仍随 Windows 包保留。

### 6.2 录像与音源

录像脚本按设定时长录制，结束后保存到选择的位置。录制期间外部 FFmpeg 正在运行，脚本等待其结束；无旧批处理文件的编码转换步骤。输出文件已存在时拒绝覆盖。

| 系统 | 屏幕 / 摄像头 | 麦克风及系统声音 |
| :--- | :--- | :--- |
| Windows | 屏幕用 gdigrab；摄像头用 DirectShow 名称 | 填写 DirectShow 音源名称；系统声音需 Stereo Mix 或回环设备 |
| macOS | 填写 AVFoundation 的屏幕或摄像头索引 | 麦克风可用索引 0；系统声音需虚拟回环音频设备索引 |
| Linux | X11 用 DISPLAY；摄像头用 `/dev/video0` 等路径 | PulseAudio / PipeWire 兼容服务的源名称；系统声音使用 monitor 源 |

设备列表可用：

```bash
# Windows
ffmpeg -list_devices true -f dshow -i dummy
# macOS
ffmpeg -f avfoundation -list_devices true -i ""
# Linux
pactl list short sources
```

这些 FFmpeg 列表命令可能以非零状态结束，但仍输出设备列表。macOS 需允许屏幕、摄像头与麦克风访问；实际请求权限的是相应录制程序。Linux 原生 Wayland 桌面不通过 X11 录制整个桌面，本适配在检测到该情况时给出提示，建议使用桌面系统提供的录屏功能。设备实现依据 [FFmpeg 官方设备文档](https://ffmpeg.org/ffmpeg-devices.html)。

### 6.3 音量与应用

Windows 保留原音量辅助工具，macOS 使用系统设置与 AppleScript，Linux 使用 `pactl` 和可选的 `pavucontrol`。常用应用分别映射到 Windows 应用、macOS 自带应用及 Linux 的编辑器 / LibreOffice / 终端；没有安装的应用会提示缺失，不自动安装。

## 7. 验证与贡献

```bash
python3 tests/chinese/test_portability.py
./PraatChineseModified --utf8 --FULL-TRUST --run tests/chinese/compatibility.praat /absolute/path/result.txt
python3 tests/chinese/run_script_checks.py /absolute/path/PraatChineseModified
```

Windows 将可执行路径换为包内 `.exe`。`--FULL-TRUST` 只应用于已审阅的仓库测试脚本：这些测试在独立目录写入样本和结果，并调用 FFmpeg 转换样本，不操作录音、录像、音量或应用启动。自动验证覆盖全部脚本的平台依赖检查、脚本控制结构、兼容数值、资源定位、PNG / PDF、代表性数据脚本和媒体转换。设备操作不在无人值守测试中自动执行。

贡献平台适配时，请提供操作系统、架构、依赖版本、构建日志及重现数据；涉及录像或音量时补充设备后端和权限状态。GitHub Actions 生成构建产物供验证，正式发布仍通过草稿 Release 检查后进行。

### 分析脚本适配与验证

91 份增强脚本保留原作者署名。历史脚本中的专用语句需要按当前 API 核查，不能直接用于任意 Praat。修改版保留必要的兼容命令，并将旧的半音换算改为明确的公式；表格导入支持带表头、无表头和原生 Table。19 份数据脚本保留安装包中的格式化写回：全部空格转为制表符，合并连续分隔符、移除空行，再分析数据；字段内空格也作为分隔符，空单元格不会保留。仅在文本发生变化时写回所选输入文件，并先在同目录保存逐字节备份（`.before-tabs.bak`，已有备份时递增编号）；目录必须可写，备份失败时不改写。原生 Table 不格式化。“只保留汉字／数字／英文”继续另存筛选结果，不覆盖输入文本。默认统计表和图形保存到便携 `data`。自动标注可按对话框选项写回用户选定的输入目录，或另存到 `data`；需要该目录具有写入权限。

`python3 tests/chinese/run_analysis_regressions.py <可执行程序>` 检查字调、起伏度、语调、按列统计和输入完整性；可用 `--tone`、`--intonation` 提供数据副本。三平台构建流程执行相同回归。涉及录音、录像、设备和交互选择的分支仍需要在相应平台人工验证。
