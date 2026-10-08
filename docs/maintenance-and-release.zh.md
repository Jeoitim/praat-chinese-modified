# 开发与发布指南

本指南对应 Jeoitim/praat-chinese-modified。开发分支为 `jeoitim-modified`，唯一同步上游为 KasumiKitsune/praat-simplified-chinese 的 `modern` 分支。发布版本从干净提交创建附注 tag，经三平台构建和附件检查后公开。以下命令供后续维护与发版参考。

## 1. 发布版本怎么命名

推荐首个修改版 tag：`v7.0.02-jeoitim.1`。其中 `7.0.02` 是 Praat 基础版本，`jeoitim.1` 是本项目的第一版修改。这个命名与原 Praat 和 KasumiKitsune 的 tag 分开。

同一基础版本的修复递增修订号，例如 `v7.0.02-jeoitim.2`。上游切换到新 Praat 版本后，再更新基础部分。首次公开测试可使用 `v7.0.02-jeoitim.1-rc.1`，并在 GitHub 标记为 prerelease。

每次发版应记录 tag、修改提交、上游基线提交、编译工具链和文件 SHA-256。程序关于页目前显示基础版本 7.0.02，发行修订号需要在 Release 标题及说明中写清楚。

## 2. 构建与草稿发布流程

`build-cross-platform.yml` 在开发分支更新和 PR 中构建 Windows x64、Linux x64 与 macOS 通用应用，并检查脚本、资源及代表性功能。下载构建产物时应保留完整资源目录。

`release.yml` 仅手动触发，要求已有的修改版 tag。三平台构建成功后，流程附上完整运行包、源码和校验和，创建新的草稿 Release。它不自动创建 tag，不公开草稿，也不覆盖已有 Release 附件。

维护者创建并推送 tag 后，可在 Actions 中运行 Prepare modified release，选择包含流程文件的开发分支并填写 tag。发布说明优先读取 `docs/release-notes-<tag>.md`。公开之前应复核平台构建结果、解压后的资源与实际语音素材，并为各平台写清验证范围。

## 3. 首次发布步骤

### 3.1 固定发布提交

先完成所有修改的提交与推送，确认工作区干净、分支正确：

```powershell
git switch jeoitim-modified
git status --short
git log -1 --oneline
git push origin jeoitim-modified
```

仓库默认开发分支为 `jeoitim-modified`。发行 tag 应从该分支上已验证的修改提交创建；使用其他分支工作时，先确认 tag 指向的内容属于修改版。

### 3.2 构建并检查完整目录

```powershell
.\build-windows.ps1
```

关闭占用同一路径的程序后再构建。检查 `dist/PraatChineseModified-7.0.02-modified`，至少应包含：

```text
PraatChineseModified.exe
assets/
  legacy/
  data/
  fonts/
  platform/
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

在一个新的目录解压测试，检查中文界面、增强菜单、声音编辑器、播放器、手册、关于页、结果输出和中文路径。还应使用自己的实际音频素材复核常用脚本。对外发布仅提供已完成相应验证的平台包，并记录设备功能的实际测试范围。

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
Compress-Archive -LiteralPath 'dist/PraatChineseModified-7.0.02-modified' -DestinationPath $runtimeZip
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

## 5. 跨平台构建与验证

Windows 使用 MinGW-w64 / MSYS2，Linux 使用 GTK 与系统音频库，macOS 使用版本匹配的官方 Xcode 工程。依赖、架构选择、完整资源打包、签名及设备限制见 [跨平台指南](cross-platform.zh.md)。

每个平台应使用独立检出或构建目录，避免复用其他平台的目标文件。发布正式 macOS 包时，需要维护者自己的签名与公证；Linux 包需要检查目标发行版的库依赖。Windows ARM64 和其他架构尚无本项目验证记录，不应将 x64 辅助工具视作其他架构的原生实现。

界面适配和算法测试分开记录：GTK/Cocoa 的外观不会自动获得 Win32 的现代控件样式。麦克风、摄像头、回环音源和桌面录制需有实际设备记录后再声明支持。
