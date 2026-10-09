"""Exercise script structure plus deterministic data/media workflows.

Interactive editor selections and physical devices are intentionally excluded.
"""
import argparse
import json
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def literal(value):
    return '"' + str(value).replace('"', '""') + '"'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("executable", type=Path)
    args = parser.parse_args()
    executable = args.executable.resolve()
    runtime = executable.parent
    if runtime.name == "MacOS": runtime = runtime.parent.parent.parent
    data = runtime / "data"
    data.mkdir(exist_ok=True)
    tested = []
    with tempfile.TemporaryDirectory(prefix="praat 脚本 checks ", dir=data) as temporary:
        base = Path(temporary)
        pref = base / "preferences"
        pref.mkdir()

        def run(path, *parameters, completion=None):
            process = subprocess.run([str(executable), "--utf8", "--FULL-TRUST", "--no-pref-files", f"--pref-dir={pref}", "--run", str(path), *map(str, parameters)],
                                     cwd=base, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=45)
            if (process.returncode or re.search(r"(?m)^Error:|^Script .*not completed", process.stderr)) and not (completion and completion in process.stderr):
                raise AssertionError(f"{path.name}: {process.returncode}\n{process.stdout}\n{process.stderr}")
            return process.stdout

        for source in sorted((ROOT / "assets/legacy").glob("*.praat")):
            # Check all control blocks without executing interactive/device code.
            code = source.read_text(encoding="utf-8")
            stack = []
            closing = {"endif": "if", "endfor": "for", "endwhile": "while", "until": "repeat", "endproc": "procedure", "endform": "form"}
            for line_number, line in enumerate(code.splitlines(),1):
                text = line.strip()
                if not text or text.startswith(("#", ";")):continue
                word = re.split(r"[\s;]",text,maxsplit=1)[0]
                if word in closing:
                    if not stack or stack[-1][0] != closing[word]:
                        raise AssertionError(f"{source.name}:{line_number}: unmatched {word}, {stack[-3:]}")
                    stack.pop()
                elif word in closing.values():stack.append((word,line_number))
                elif word in ("else", "elsif"):
                    assert stack and stack[-1][0] == "if", (source.name,line_number,word)
            assert not stack,(source.name,stack)
            tested.append(source.name)

        for name, parameters in [("ak", [1000]), ("al", [5]), ("an", [200, 100]), ("ao", [12, 100]), ("ae", [])]:
            run(ROOT / f"assets/legacy/{name}.praat", *parameters)

        fixture = base / "样本 中文 & 空格.txt"
        fixture.write_text("声音声音研究 abc 123\n", encoding="utf-8")
        for name, parameters, completion in [("dr", ["只保留汉字"], "完成"), ("ds", ["只包括汉字"], "完成")]:
            code = (ROOT / f"assets/legacy/{name}.praat").read_text(encoding="utf-8")
            code = re.sub(r'chooseReadFile\$\s*(?:\([^\n]*\)|:\s*"[^\n]*")', lambda match: literal(fixture), code)
            script = base / f"{name}.praat"
            script.write_text(code, encoding="utf-8")
            run(script, *parameters, completion=completion)
        character_result = next(data.glob("*保留纯汉字*.txt"))
        result = character_result.read_text(encoding="utf-8-sig")
        assert "声音" in result and "abc" not in result and "123" not in result
        frequency = next(data.glob("*字频*.tsv"))
        assert "频率" in frequency.read_text(encoding="utf-8-sig")

        run(ROOT / "assets/legacy/do.praat", "帮", "", "", "", "", "", "", "yes")

        plot = base / "export.praat"
        image = base / ("图形 中文.png" if executable.suffix.lower() == ".exe" else "图形 中文.pdf")
        export_command = "Save as 600-dpi PNG file" if image.suffix == ".png" else "Save as PDF file"
        plot.write_text(f'runScript: {literal(ROOT / "assets/legacy/by.praat")}\n{export_command}: {literal(image)}\n', encoding="utf-8")
        run(plot)
        assert image.read_bytes().startswith(b"\x89PNG" if image.suffix == ".png" else b"%PDF")

        # Exercise both relative and new absolute-duration T-value averaging.
        for graph_name in ["s", "dl"]:
            graph = base / (graph_name + "-average.praat")
            code = 'Create Table with column names: "tones", 2, "tone dot1 dot2 dot3 dot4 dot5 dot6 dot7 dot8 dot9 duration"\n'
            code += 'Set string value: 1, "tone", "A"\nSet string value: 2, "tone", "B"\n'
            for row in [1,2]:
                for dot in range(1,10):code += f'Set numeric value: {row}, "dot{dot}", {row + dot/10}\n'
                code += f'Set numeric value: {row}, "duration", {0.2*row}\n'
            code += f'runScript: {literal(ROOT / ("assets/legacy/" + graph_name + ".praat"))}, "yes", "yes", "Blue", "{graph_name}-average", "{graph_name}-average"\n'
            graph.write_text(code,encoding="utf-8")
            run(graph)
            assert (data/(graph_name+"-average.xls")).is_file()
            assert any((data).glob(graph_name+"-average.*"))

        ffmpeg = shutil.which("ffmpeg")
        if not ffmpeg:
            for candidate in [executable.parent / "ffmpeg.exe", ROOT / "assets/tools/ffmpeg.exe"]:
                if candidate.is_file():
                    ffmpeg = str(candidate)
                    break
        if not ffmpeg:
            raise AssertionError("FFmpeg is needed for the media smoke test")
        media = base / "媒体 中文 & 空格"
        media.mkdir()
        subprocess.run([ffmpeg, "-nostdin", "-v", "error", "-f", "lavfi", "-i", "testsrc=size=64x64:rate=5:duration=1",
                        "-f", "lavfi", "-i", "sine=frequency=200:duration=1", "-c:v", "mpeg4", "-c:a", "aac", "-shortest", str(media/"原始 视频.mp4")],check=True)
        run(ROOT / "assets/legacy/z.praat", media)
        assert (data/"原始 视频.wav").is_file()
        run(ROOT / "assets/legacy/y.praat", media)
        assert (data/"new原始 视频.mp4").is_file()
        converted = base / "convert"
        converted.mkdir()
        shutil.copyfile(data/"原始 视频.wav", converted/"声音 & 空格.wav")
        run(ROOT / "assets/legacy/ca.praat", converted, "wav", "flac")
        assert (data/"声音 & 空格.flac").is_file()
        print(json.dumps({"script_control_structure_checked": len(tested), "data_workflows": ["character extraction", "character frequency", "phonological query"],
                          "native_workflows": ["numerical helpers", "IPA table", "PNG/PDF", "relative/absolute T-value averaging"], "media_workflows": ["extract audio", "remove audio", "convert"],
                          "hardware_tested": False}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
