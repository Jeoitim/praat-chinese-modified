"""Tests for platform contracts and paths, without changing devices or volumes."""
import importlib.util
import os
import re
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    value = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(value)
    return value


tools = module("platform_tools", ROOT / "assets/platform/platform_tools.py")
words = module("word_tools", ROOT / "assets/platform/word_tools.py")


class PortabilityTests(unittest.TestCase):
    def test_all_supplied_scripts_have_no_windows_shell_or_absolute_deployment(self):
        scripts = list((ROOT / "assets/legacy").glob("*.praat"))
        self.assertEqual(len(scripts), 91)
        for script in scripts:
            code = "\n".join(line for line in script.read_text(encoding="utf-8").splitlines() if not line.lstrip().startswith("#"))
            self.assertNotRegex(code, r"(?im)^\s*(?:nocheck\s+)?(?:system\s|runSystem\s*[:(])", script.name)
            self.assertNotRegex(code, r"(?i)[a-z]:[\\/]|Save as Windows metafile|\.emf|\.bat|\\scrpt", script.name)
            self.assertNotRegex(code, r"'[\w]+\$'\\", script.name)

    def test_analysis_scripts_use_portable_data_and_current_functions(self):
        for script in (ROOT / "assets/legacy").glob("*.praat"):
            code = "\n".join(line for line in script.read_text(encoding="utf-8").splitlines() if not line.lstrip().startswith("#"))
            self.assertNotIn('preferencesDirectory$ + "/data"', code, script.name)
            self.assertNotRegex(code, r"hertzToSemitonesRe(?:50|64)", script.name)
            self.assertNotIn('Save as raw text file: pathFileName$', code, script.name)
            self.assertNotIn("'stringsFileName$'", code if script.stem in ("da", "db", "dc") else "", script.name)

    def test_capture_argv_keeps_spaces_unicode_and_metacharacters_as_data(self):
        output = '/tmp/语音 实验 & $测试.mp4'
        args = tools.capture_arguments("Windows", "screen-mix", "ffmpeg", output, 5, "auto", 'mic & "name"', "loopback")
        self.assertIn('audio=mic & "name"', args)
        self.assertEqual(args[-1], output)
        self.assertIn("[1:a][2:a]amix=inputs=2:duration=first:dropout_transition=2[a]", args)
        self.assertIn("-n", args)

    def test_capture_devices_all_platforms(self):
        for system, video, mic, audio, expected in [
            ("Windows", "Camera", "Microphone", "Stereo Mix", "dshow"),
            ("Darwin", "1", "0", "2", "avfoundation"),
            ("Linux", "/dev/video0", "default", "monitor.source", "v4l2"),
        ]:
            args = tools.capture_arguments(system, "camera-mix", "ffmpeg", "out.mp4", 1, video, mic, audio)
            self.assertIn(expected, args)
            self.assertEqual(args.count("-i"), 3)

    def test_screen_requires_explicit_capability_and_loopback(self):
        with patch.dict(os.environ, {"DISPLAY": "", "XDG_SESSION_TYPE": "wayland"}):
            with self.assertRaises(ValueError):
                tools.capture_arguments("Linux", "screen", "ffmpeg", "out.mp4", 1, "auto", "default", "default")
        for system, video in [("Windows", "auto"), ("Darwin", "2"), ("Linux", ":0")]:
            with self.assertRaises(ValueError):
                tools.capture_arguments(system, "screen-mix", "ffmpeg", "out.mp4", 1, video, "default", "default")

    def test_word_frequencies_preserve_part_of_speech(self):
        from collections import namedtuple
        Word = namedtuple("Word", "word flag")
        result = words.analyse("text", lambda text: iter([Word("声音", "n"), Word("声音", "n"), Word("声音", "v"), Word(" ", "x")]))
        self.assertEqual(result, {("声音", "n"): 2, ("声音", "v"): 1})

    def test_watermark_remains_text_data(self):
        with tempfile.TemporaryDirectory() as temporary:
            output = str(Path(temporary)/"sample.mp4")
            with patch.object(tools, "executable"), patch.object(tools.platform, "system", return_value="Darwin"), patch.object(tools.subprocess, "run") as run:
                tools.run_capture(["screen", "ffmpeg", output, "1", "2", "0", "unused", "text':evil=1", "red", "50"])
            argv = run.call_args.args[0]
            self.assertNotIn("text':evil=1", " ".join(argv))
            self.assertIn("drawtext=textfile=watermark.txt:expansion=none:fontcolor=red:fontsize=50:x=50:y=50", argv)


if __name__ == "__main__":
    unittest.main()
