# 开发与发布指南

本指南对应 Jeoitim/praat-chinese-modified。开发分支为 `jeoitim-modified`，唯一同步上游为 KasumiKitsune/praat-simplified-chinese 的 `modern` 分支。以下命令是在发布时手动执行的步骤，不代表已经创建 tag 或 Release。

## 1. 发布版本怎么命名

推荐首个修改版 tag：`v7.0.02-jeoitim.1`。其中 `7.0.02` 是 Praat 基础版本，`jeoitim.1` 是本项目的第一版修改。这个命名与原 Praat 和 KasumiKitsune 的 tag 分开。

同一基础版本的修复递增修订号，例如 `v7.0.02-jeoitim.2`。上游切换到新 Praat 版本后，再更新基础部分。首次公开测试可使用 `v7.0.02-jeoitim.1-rc.1`，并在 GitHub 标记为 prerelease。

每次发版应记录 tag、修改提交、上游基线提交、编译工具链和文件 SHA-256。程序关于页目前显示基础版本 7.0.02，发行修订号需要在 Release 标题及说明中写清楚。

## 2. 当前发布工作流的问题

仓库继承的 `.github/workflows/release.yml` 不适合直接发布当前修改版：

- Windows 包只包含 `Praat.exe` 和旧 `README.txt`，没有增强脚本、参考表格、字体、关于页及辅助工具。
- 默认采用 x64v3，本地已验证版本采用兼容范围更广的 x64v1。
- 工作流可对已存在的 Release 使用 `--clobber`，会替换附件。正式版本应发布新的修订号。
- macOS 参数仍指向较早的 Xcode 模板，工程补丁没有加入 `sys/praat_chinese.cpp`，也没有安排新增资源的 `.app` 打包。

在工作流补齐前，先采用下面的本地构建和草稿发布步骤。不要把旧工作流产出的 exe-only 压缩包作为完整修改版发布。

## 3. 首次发布步骤

### 3.1 固定发布提交

先完成所有修改的提交与推送，确认工作区干净、分支正确：

```powershell
git switch jeoitim-modified
git status --short
git log -1 --oneline
git push origin jeoitim-modified
```

当前 GitHub 默认分支仍是 `master`，它不是修改版开发分支。建议在仓库 Settings → Branches 中将默认分支设为 `jeoitim-modified`。无论默认分支是什么，都要从已验证的修改分支创建 tag，避免把原始上游提交当成修改版发布。

### 3.2 构建并检查完整目录

```powershell
.\build-windows.ps1
```

关闭占用同一路径的程序后再构建。检查 `dist/PraatChineseModified-7.0.02-modern`，至少应包含：

```text
PraatChineseModified.exe
assets/
  legacy/
  data/
  fonts/
  docs/
  about.html
  icon.png
ffmpeg.exe
ffplay.exe
音量辅助程序
README-修改版.md
THIRD_PARTY_NOTICES.md
gpl-3.0.txt
```

在一个新的目录解压测试，检查中文界面、增强菜单、声音编辑器、播放器、手册、关于页、结果输出和中文路径。还应使用自己的实际音频素材复核常用脚本。首次对外发布建议只提供已经验证的 Windows x64 包。

### 3.3 创建附注 tag 与附件

下面示例使用首个正式修改版 tag。若它已经存在，应选择下一修订号。

```powershell
$releaseTag = 'v7.0.02-jeoitim.1'
git tag -a $releaseTag -m "Praat 修改版 $releaseTag"
git push origin $releaseTag

$releaseFolder = Join-Path (Get-Location) "dist/releases/$releaseTag"
New-Item -ItemType Directory -Path $releaseFolder -Force | Out-Null

$runtimeZip = Join-Path $releaseFolder "PraatChineseModified-$releaseTag-Windows-x64.zip"
$sourceZip = Join-Path $releaseFolder "PraatChineseModified-$releaseTag-source.zip"
Compress-Archive -LiteralPath 'dist/PraatChineseModified-7.0.02-modern' -DestinationPath $runtimeZip
git archive --format=zip --prefix=PraatChineseModified-source/ "--output=$sourceZip" $releaseTag

$checksumFile = Join-Path $releaseFolder 'SHA256SUMS.txt'
$checksumLines = Get-FileHash -LiteralPath $runtimeZip,$sourceZip -Algorithm SHA256 |
    ForEach-Object { $_.Hash.ToLowerInvariant() + '  ' + [System.IO.Path]::GetFileName($_.Path) }
[System.IO.File]::WriteAllText($checksumFile, ($checksumLines -join "`n") + "`n", [System.Text.UTF8Encoding]::new($false))
```

源码包从 tag 生成，避免把工作区中的临时文件或未提交修改混进附件。运行包和源码包应对应同一份经过验证的代码；不要把旧构建目录和新的 source tag 拼在一起。

### 3.4 先创建草稿 Release

编辑 `docs/release-notes-v7.0.02-jeoitim.1.md`，确认内容与实际验证范围一致。然后执行：

```powershell
gh release create $releaseTag $runtimeZip $sourceZip $checksumFile `
  --repo Jeoitim/praat-chinese-modified `
  --verify-tag `
  --draft `
  --title "Praat 修改版 $releaseTag" `
  --notes-file docs/release-notes-v7.0.02-jeoitim.1.md
```

候选版在创建时再加 `--prerelease`。`--verify-tag` 要求 tag 已在远程存在，防止 CLI 自动在默认分支创建另一个 tag。

打开草稿页面，核对 tag 提交、附件、校验值、署名、许可和已知限制。确认后在网页点击发布，或执行：

```powershell
gh release edit $releaseTag --repo Jeoitim/praat-chinese-modified --draft=false
```

已发布版本出现问题时发布下一修订号，不移动原 tag，也不覆盖旧附件。若启用 GitHub 的 immutable releases，应先把全部附件传到草稿，再发布。

GitHub 官方说明：[创建 Release](https://cli.github.com/manual/gh_release_create)、[管理 Release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)。

## 4. 跟进上游的工作流

### 4.1 分支职责

| 分支 | 用途 |
| :--- | :--- |
| `modern` | 保留 KasumiKitsune modern 的镜像，不加入本项目修改 |
| `jeoitim-modified` | 日常开发、构建和发布修改版 |
| `sync/modern-日期` | 处理某次上游同步，完成检查后合入修改分支 |
| 发行 tag | 固定已发布版本，不随开发分支移动 |

同步对象必须是 `upstream/modern`。GitHub 的普通 Sync fork 或 `gh repo sync` 默认可能跟随上游默认 `master`，不能不加区分地用于本项目。

### 4.2 同步步骤

先确认工作区干净，再更新上游镜像：

```powershell
git fetch upstream
git switch modern
git merge --ff-only upstream/modern
git push origin modern
```

然后从修改分支建立一次独立的同步分支。把日期换成实际同步日期：

```powershell
git switch jeoitim-modified
git pull --ff-only origin jeoitim-modified
git switch -c sync/modern-2026-10-08
git merge upstream/modern
```

解决冲突时优先保留上游的算法和平台修复，再复核本项目的资源路径、菜单层级、术语表、关于页及构建脚本。当前克隆较浅；遇到缺少合并历史的提示时，按需要补充历史，不使用强制同步覆盖修改分支。

完成构建、兼容测试和实际素材检查后，把同步分支推到自己的仓库，通过 PR 合入 `jeoitim-modified`。PR 的目标是本 fork，而不是 KasumiKitsune 的仓库。

```powershell
git push -u origin sync/modern-2026-10-08
gh pr create --repo Jeoitim/praat-chinese-modified `
  --base jeoitim-modified --head sync/modern-2026-10-08
```

已公开的修改分支采用 merge 同步，保留发布提交的历史关系。不要为了跟进上游对发布历史反复 rebase，也不要强推覆盖已有 tag。确认上游重要更新后再同步，比每次提交都直接合入发布分支更容易验证。

参考：[GitHub 的 fork 同步说明](https://docs.github.com/en/pull-requests/how-tos/work-with-forks/syncing-a-fork)。

## 5. 跨平台构建还差哪些工作

### 5.1 Windows

当前 x64v1 构建已完成。MSYS2/Clang64 可以作为后续 CI 的工具链，但完整资源打包和测试要与本地版本一致。ARM64 需要单独构建与验证，不能把 x64 辅助工具随同 ARM64 包直接宣称为原生支持。

### 5.2 Linux

核心程序、通用汉化和 GTK 界面有现成构建基础。主要工作是安装编译和音频/GTK 依赖，处理资源定位与打包，再测试真实桌面会话。当前非 Windows 的资源定位取自启动工作目录，还没有做到可靠的可执行文件相对定位。

HTML 关于页目前只有 Windows 打开实现，私有字体加载也只有 Windows 实现。增强脚本中的反斜杠、`system start`、批处理、Windows 图元文件及 `.exe` 工具还需适配或按平台隐藏。Linux 通用构建入口可参照 HOW_TO_BUILD_ONE.md，但目前没有验证本修改版的 Linux 产物。

### 5.3 macOS

上游使用 Xcode 构建。需要为正确的 Praat 基线取得匹配的工程文件，加入 `sys/praat_chinese.cpp` 和头文件，把脚本、字体、图标和 HTML 放进 `.app`，并将资源定位改为使用 bundle 资源路径。

本修改版默认数据路径、字体注册、HTML 打开方式和增强脚本还需测试。公开分发的 `.app` / `.dmg` 还要处理签名、公证和 Gatekeeper；在这些步骤完成前不应发布“已支持 macOS”的声明。

### 5.4 难度判断

把核心算法和中文界面编译到 Linux、macOS，属于可以分步推进的适配工作。把 Windows 的 Win32 现代控件一并搬过去，则需要 Cocoa 或 GTK 的对应实现，工作量明显更大。

建议顺序：先稳定 Windows 发版，再完成 Linux 的构建与资源适配，最后处理 macOS 的工程、bundle 和分发。每个平台通过实际测试后再添加对应 Release 附件。
