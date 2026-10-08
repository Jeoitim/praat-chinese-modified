param([int]$Jobs = 12)
$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$compiler = Get-Command g++ -ErrorAction Stop
$compilerDirectory = Split-Path $compiler.Source
$gitCommand = Get-Command git -ErrorAction Stop
$gitRoot = Split-Path (Split-Path $gitCommand.Source)
$shellCandidates = @((Join-Path $gitRoot 'usr/bin/bash.exe'), "$env:USERPROFILE/scoop/apps/git/current/usr/bin/bash.exe", 'C:/Program Files/Git/usr/bin/bash.exe')
$bashPath = $shellCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (!$bashPath) { throw 'Git for Windows bash.exe was not found.' }
$env:PATH = $compilerDirectory + ';' + (Split-Path $bashPath) + ';' + $env:PATH
$makePath = Join-Path $compilerDirectory 'mingw32-make.exe'
Push-Location $projectPath
try {
    $makeArguments = @('PRAAT_OS=windows','PRAAT_COMPILER=gcc','PRAAT_ARCH=x64v1','EXECUTABLE_FILE=PraatChineseModified.exe',("SHELL=" + $bashPath.Replace('\','/')),("-j" + $Jobs))
    # Recent WinLibs GCC adds a default manifest automatically. Use our complete
    # manifest (Common Controls, GDI scaling, long paths, asInvoker) exactly once.
    $compilerSpecs = (& $compiler.Source -dumpspecs) -join "`n"
    $endFileMatch = [regex]::Match($compilerSpecs, '(?m)^\*endfile:\n([^\n]*)')
    if ($endFileMatch.Success -and $endFileMatch.Groups[1].Value.Contains('default-manifest.o')) {
        $endFileBody = $endFileMatch.Groups[1].Value.Replace('%{!shared:%:if-exists(default-manifest.o%s)}','')
        $specDirectory = Join-Path $projectPath 'build'
        New-Item -ItemType Directory -Path $specDirectory -Force | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $specDirectory 'no-default-manifest.specs'), "*endfile:`n" + $endFileBody + "`n", [System.Text.UTF8Encoding]::new($false))
        $makeArguments += 'LINKER_COMMAND=g++ -specs=build/no-default-manifest.specs'
    }
    & $makePath @makeArguments
    if ($LASTEXITCODE -ne 0) { throw 'Build failed.' }
    $packageDirectory = Join-Path $projectPath 'dist/PraatChineseModified-7.0.02-modern'
    New-Item -ItemType Directory -Path $packageDirectory -Force | Out-Null
    Copy-Item -LiteralPath 'PraatChineseModified.exe' -Destination (Join-Path $packageDirectory 'PraatChineseModified.exe')
    $packageAssets = Join-Path $packageDirectory 'assets'
    New-Item -ItemType Directory -Path $packageAssets -Force | Out-Null
    Get-ChildItem -LiteralPath 'assets' -Force | Where-Object { $_.Name -ne 'tools' } | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $packageAssets -Recurse -Force }
    Copy-Item -LiteralPath 'README-修改版.md','THIRD_PARTY_NOTICES.md','main/gpl-3.0.txt' -Destination $packageDirectory -Force
    $packageDocs = Join-Path $packageDirectory 'docs'
    New-Item -ItemType Directory -Path $packageDocs -Force | Out-Null
    Copy-Item -LiteralPath 'docs/maintenance-and-release.zh.md','docs/release-notes-v7.0.02-jeoitim.1.md' -Destination $packageDocs -Force
    if (Test-Path -LiteralPath 'assets/tools') {
        Get-ChildItem -LiteralPath 'assets/tools' -File | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $packageDirectory -Force }
    }
} finally { Pop-Location }
