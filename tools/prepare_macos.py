"""Prepare the official version-matched Xcode project for this fork."""
import hashlib
import re
import shutil
import urllib.request
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODULES = ["praat_translate", "praat_chinese", "praat_legacy_io", "praat_python", "PythonScriptEditor", "PreferencesDialog"]


def patch_project(text):
    references = []
    builds = []
    members = []
    sources = []
    for name in MODULES:
        if re.search(r"/\* " + re.escape(name) + r"\.cpp \*/ =", text):
            continue
        source_id = hashlib.sha1((name + ":source").encode()).hexdigest()[:24].upper()
        build_id = hashlib.sha1((name + ":build").encode()).hexdigest()[:24].upper()
        header_id = hashlib.sha1((name + ":header").encode()).hexdigest()[:24].upper()
        references += [f'\t\t{source_id} /* {name}.cpp */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.cpp.objcpp; path = sys/{name}.cpp; sourceTree = SOURCE_ROOT; }};',
                       f'\t\t{header_id} /* {name}.h */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.c.h; path = sys/{name}.h; sourceTree = SOURCE_ROOT; }};']
        builds += [f'\t\t{build_id} /* {name}.cpp in Sources */ = {{isa = PBXBuildFile; fileRef = {source_id}; }};']
        members += [f'\t\t\t\t{source_id} /* {name}.cpp */,', f'\t\t\t\t{header_id} /* {name}.h */,']
        sources += [f'\t\t\t\t{build_id} /* {name}.cpp in Sources */,']
    if sources:
        for section, values in [("PBXBuildFile", builds), ("PBXFileReference", references)]:
            marker = f"/* Begin {section} section */\n"
            if marker not in text:
                raise ValueError(f"Xcode project missing {section}")
            text = text.replace(marker, marker + "\n".join(values) + "\n", 1)
        group = re.search(r"mainGroup = ([A-F0-9]{24})", text).group(1)
        pattern = r"(" + group + r"[^{}]*\{\s*isa = PBXGroup;.*?children = \(\n)"
        text, count = re.subn(pattern, lambda m: m[1] + "\n".join(members) + "\n", text, count=1, flags=re.S)
        if count != 1:
            raise ValueError("Xcode project main group missing")
        text, count = re.subn(r"(isa = PBXSourcesBuildPhase;.*?files = \(\n)", lambda m: m[1] + "\n".join(sources) + "\n", text, flags=re.S)
        if count < 1:
            raise ValueError("Xcode project source phase missing")
    text = re.sub(r"DEVELOPMENT_TEAM = [^;]+;", 'DEVELOPMENT_TEAM = "";', text)
    text = re.sub(r'CODE_SIGN_IDENTITY = [^;]+;', 'CODE_SIGN_IDENTITY = "-";', text)
    text = text.replace('CODE_SIGN_STYLE = Automatic;', 'CODE_SIGN_STYLE = Manual;')
    text = text.replace('INFOPLIST_PREFIX_HEADER = /Users/pboersma/Dropbox/Praats/src/sys/praat_version.h;', 'INFOPLIST_PREFIX_HEADER = main/main_Praat.h;')
    text = text.replace('CLANG_CXX_LANGUAGE_STANDARD = "gnu++0x";', 'CLANG_CXX_LANGUAGE_STANDARD = "gnu++17";')
    return text


def main():
    version = re.search(r"#define PRAAT_VERSION_STR\s+(\S+)", (ROOT / "main/main_Praat.h").read_text()).group(1)
    version = version.strip('"')
    digits = version.replace(".", "")
    url = f"https://github.com/praat/praat.github.io/releases/download/v{version}/praat{digits}_xcodeproj.zip"
    download = ROOT / "build" / f"praat{digits}_xcodeproj.zip"
    download.parent.mkdir(exist_ok=True)
    if not download.exists():
        urllib.request.urlretrieve(url, download)
    # This exact template was inspected when the cross-platform support was added.
    if version == "7.0.02":
        expected = "db518760d2dd78c98da68e380d721bedb4825ee63eb8da37f0a3be813fabef5b"
        if hashlib.sha256(download.read_bytes()).hexdigest() != expected:
            raise ValueError("Official Xcode template checksum mismatch")
    with zipfile.ZipFile(download) as archive:
        for item in archive.infolist():
            if item.filename.startswith("praat.xcodeproj/") and not item.is_dir():
                path = ROOT / item.filename
                if not path.resolve().is_relative_to(ROOT / "praat.xcodeproj"):
                    raise ValueError("Invalid template path")
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(archive.read(item))
    project = ROOT / "praat.xcodeproj/project.pbxproj"
    project.write_text(patch_project(project.read_text()), encoding="utf-8")
    print(f"Prepared Xcode project from {url}")


if __name__ == "__main__":
    main()
