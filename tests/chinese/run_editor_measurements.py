"""Run real pitch/amplitude scripts in a separate GUI instance, with no devices."""
import argparse
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("executable", type=Path)
    executable = parser.parse_args().executable.resolve()
    runtime = executable.parent
    if runtime.name == "MacOS": runtime = runtime.parent.parent.parent
    data = runtime / "data"
    data.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="editor_check_", dir=data) as temporary:
        base = Path(temporary)
        for name, label in [("a", "tone"), ("p", "unit")]:
            code = (ROOT / f"assets/legacy/{name}.praat").read_text(encoding="utf-8")
            start = code.index("beginPause:")
            end = code.index("\n", code.index("clicked = endPause:", start))
            code = code[:start] + f'print_title_of_data = 1\n{label}$ = "portable_test"' + code[end:]
            (base / f"{name}.praat").write_text(code, encoding="utf-8")
        result = base / "result.txt"
        code = '''Create Sound from formula: "gui_portable", 1, 0, 0.5, 22050, "0.5*sin(2*pi*200*x)"
View & Edit
editor Sound gui_portable
Show analyses: "yes", "yes", "yes", "yes", "yes", 10
Select: 0.1, 0.3
'''
        for name in ["a", "p"]: code += f'runScript: "{base/name}.praat"\n'
        code += '''endeditor
assert fileReadable(dataDirectory$ + "/tone.txt")
assert fileReadable(dataDirectory$ + "/amplitude.txt")
'''
        code += f'writeFileLine: "{result}", "PASS: editor pitch and amplitude saved"\n'
        code += "select all\nRemove\nQuit\n"
        script = base / "test.praat"
        script.write_text(code, encoding="utf-8")
        options = {}
        if hasattr(subprocess, "STARTUPINFO"):
            info = subprocess.STARTUPINFO()
            info.dwFlags |= subprocess.STARTF_USESHOWWINDOW
            info.wShowWindow = 0
            options["startupinfo"] = info
        subprocess.run([str(executable), "--new-send", "--FULL-TRUST", str(script)],
                       cwd=base, timeout=60, check=True, **options)
        assert "PASS" in result.read_text(encoding="utf-8-sig")
        assert (runtime / "settings" / "Preferences.txt").is_file()
        for filename in ["tone.txt", "amplitude.txt"]:
            assert "portable_test" in (data / filename).read_text(encoding="utf-8-sig")
        print("PASS: actual editor measurements, portable data and persisted settings")

if __name__ == "__main__": main()
