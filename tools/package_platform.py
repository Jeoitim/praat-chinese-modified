"""Package the complete modified edition, without Windows tools on Unix."""
import argparse
import plistlib
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def copy_resources(target):
    target.mkdir(parents=True, exist_ok=True)
    shutil.copytree(ROOT / "assets", target / "assets", dirs_exist_ok=True,
                    ignore=lambda path, names: [name for name in names if name == "tools" or name == "__pycache__"])
    for name in ["README-修改版.md", "THIRD_PARTY_NOTICES.md"]:
        shutil.copyfile(ROOT / name, target / name)
    shutil.copyfile(ROOT / "main/gpl-3.0.txt", target / "gpl-3.0.txt")
    (target / "docs").mkdir(exist_ok=True)
    for name in ["maintenance-and-release.zh.md", "cross-platform.zh.md"]:
        shutil.copyfile(ROOT / "docs" / name, target / "docs" / name)
    assert len(list((target / "assets/legacy").glob("*.praat"))) == 91


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("platform", choices=["linux", "macos", "windows"])
    parser.add_argument("executable", type=Path)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    if args.destination.exists():
        raise ValueError("Package destination already exists; choose a new build folder.")
    if args.platform == "macos":
        shutil.copytree(args.executable, args.destination)
        resources = args.destination / "Contents/Resources"
        copy_resources(resources)
        info_file = args.destination / "Contents/Info.plist"
        info = plistlib.loads(info_file.read_bytes())
        original_binary = args.destination / "Contents/MacOS/Praat"
        original_binary.rename(args.destination / "Contents/MacOS/PraatChineseModified")
        info.update(CFBundleExecutable="PraatChineseModified", CFBundleName="Praat 修改版", CFBundleDisplayName="Praat 修改版",
                    CFBundleIdentifier="io.github.jeoitim.PraatChineseModified",
                    NSMicrophoneUsageDescription="录制和分析语音。",
                    NSCameraUsageDescription="录制语音实验视频。",
                    CFBundleIconFile="PraatChineseModified.icns")
        iconset = ROOT / "build/modified.iconset"
        iconset.mkdir(parents=True, exist_ok=True)
        for size in [16, 32, 128, 256, 512]:
            for scale in [1, 2]:
                name = f"icon_{size}x{size}" + ("@2x" if scale == 2 else "") + ".png"
                subprocess.run(["sips", "-z", str(size*scale), str(size*scale), str(ROOT/"assets/icon.png"), "--out", str(iconset/name)],check=True)
        subprocess.run(["iconutil", "-c", "icns", str(iconset), "-o", str(resources/"PraatChineseModified.icns")],check=True)
        info_file.write_bytes(plistlib.dumps(info))
        # Resources and Info.plist must be final before signing.
        subprocess.run(["codesign", "--force", "--deep", "--sign", "-", str(args.destination)],check=True)
    else:
        copy_resources(args.destination)
        name = "PraatChineseModified.exe" if args.platform == "windows" else "PraatChineseModified"
        shutil.copy2(args.executable, args.destination/name)
        if args.platform == "windows":
            for file in (ROOT/"assets/tools").iterdir():
                if file.is_file():shutil.copy2(file,args.destination/file.name)
        else:
            (args.destination/name).chmod(0o755)
    print(f"Complete {args.platform} package: {args.destination}")


if __name__ == "__main__":
    main()
