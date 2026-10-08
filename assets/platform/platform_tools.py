"""Platform adapters for scripts by 贝先明、向柠; adaptations by jeoitim.

All child processes receive an argument list, never a shell command.
"""
import os
import platform
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


def executable(name):
    found = shutil.which(name)
    if not found:
        raise RuntimeError(f"找不到 {name}，请先安装或配置可执行程序路径。")
    return found


def capture_arguments(system, mode, ffmpeg, output, duration, video, mic, audio):
    duration = float(duration)
    if duration <= 0:
        raise ValueError("录制时长必须大于零。")
    dual = mode.endswith("-mix")
    camera = mode == "camera-mix"
    args = [ffmpeg, "-nostdin", "-n"]
    if system == "Windows":
        if mic == "default" or (dual and audio == "default"):
            raise ValueError("Windows 录制需要填写 DirectShow 设备名称，请先查看设备列表。")
        if camera:
            if video == "auto":
                raise ValueError("请填写摄像头的 DirectShow 名称。")
            args += ["-thread_queue_size", "1024", "-f", "dshow", "-i", "video=" + video]
        else:
            args += ["-f", "gdigrab", "-framerate", "25", "-i", "desktop"]
        args += ["-thread_queue_size", "1024", "-f", "dshow", "-i", "audio=" + mic]
        if dual:
            args += ["-thread_queue_size", "1024", "-f", "dshow", "-i", "audio=" + audio]
    elif system == "Darwin":
        if video == "auto":
            raise ValueError("macOS 请填写 AVFoundation 视频设备索引；屏幕和摄像头有各自索引。")
        if mic == "default":
            mic = "0"
        args += ["-f", "avfoundation", "-framerate", "25", "-i", video + ":none"]
        args += ["-f", "avfoundation", "-i", "none:" + mic]
        if dual:
            if audio == "default":
                raise ValueError("macOS 系统声音需要虚拟回环音频设备，请填写其 AVFoundation 索引。")
            args += ["-f", "avfoundation", "-i", "none:" + audio]
    elif system == "Linux":
        if camera:
            args += ["-f", "v4l2", "-framerate", "25", "-i", "/dev/video0" if video == "auto" else video]
        else:
            display = os.environ.get("DISPLAY", "") if video == "auto" else video
            if not display:
                raise ValueError("屏幕录制需要 X11 DISPLAY；Wayland 原生桌面请使用系统录屏工具。")
            if os.environ.get("XDG_SESSION_TYPE") == "wayland" and video == "auto":
                raise ValueError("当前为 Wayland 会话，X11 录制不能保证捕获完整桌面。请使用系统录屏工具。")
            args += ["-f", "x11grab", "-framerate", "25", "-i", display]
        args += ["-thread_queue_size", "1024", "-f", "pulse", "-i", mic]
        if dual:
            if audio == "default":
                raise ValueError("系统声音请填写 PulseAudio/PipeWire 的 monitor 源，不能再次使用默认麦克风。")
            args += ["-thread_queue_size", "1024", "-f", "pulse", "-i", audio]
    else:
        raise ValueError("当前平台尚无录像设备适配。")
    args += ["-map", "0:v:0"]
    if dual:
        args += ["-filter_complex", "[1:a][2:a]amix=inputs=2:duration=first:dropout_transition=2[a]", "-map", "[a]"]
    else:
        args += ["-map", "1:a:0"]
    return args + ["-t", str(duration), "-pix_fmt", "yuv420p", output]


def run_capture(arguments):
    mode, ffmpeg, output, duration, video, mic, audio, text, color, size = arguments
    executable(ffmpeg)
    if Path(output).exists():
        raise ValueError("输出文件已存在，请换一个文件名。")
    args = capture_arguments(platform.system(), mode, ffmpeg, output, duration, video, mic, audio)
    with tempfile.TemporaryDirectory(prefix="praat_capture_") as temporary:
        if text:
            # Only generated filenames enter filter syntax; watermark content is data.
            font_size = int(float(size))
            if not 1 <= font_size <= 500:
                raise ValueError("水印字号须在 1 至 500 之间。")
            if not color.isalpha() and not (color.startswith("#") and all(c in "0123456789abcdefABCDEF" for c in color[1:])):
                raise ValueError("水印颜色须为颜色名称或十六进制色值。")
            Path(temporary, "watermark.txt").write_text(text, encoding="utf-8")
            # Run in the temporary folder so Windows drive letters need no FFmpeg escaping.
            args[-1:-1] = ["-vf", f"drawtext=textfile=watermark.txt:expansion=none:fontcolor={color}:fontsize={font_size}:x=50:y=50"]
        subprocess.run(args, cwd=temporary, check=True)


def volume(kind, action, resources):
    system = platform.system()
    action = int(float(action))
    if system == "Windows":
        if action == 1:
            os.startfile("ms-settings:sound")
        else:
            name = ("调整播放音量" if kind == "playback" else "调整录音音量") + ("为0.exe" if action == 2 else "为100.exe")
            path = Path(resources, name)
            if not path.is_file():
                path = Path(resources, "assets", "tools", name)
            if not path.is_file():
                raise ValueError("Windows 音量辅助工具缺失，请检查完整资源包。")
            subprocess.Popen([str(path)])
    elif system == "Darwin":
        if action == 1:
            subprocess.run(["open", "x-apple.systempreferences:com.apple.Sound-Settings.extension"], check=True)
        else:
            channel = "output" if kind == "playback" else "input"
            subprocess.run(["osascript", "-e", f"set volume {channel} volume {0 if action == 2 else 100}"], check=True)
    elif system == "Linux":
        if action == 1:
            subprocess.Popen([executable("pavucontrol")])
        else:
            channel = "sink" if kind == "playback" else "source"
            default = "@DEFAULT_SINK@" if kind == "playback" else "@DEFAULT_SOURCE@"
            subprocess.run([executable("pactl"), f"set-{channel}-volume", default, "0%" if action == 2 else "100%"], check=True)
    else:
        raise ValueError("此平台尚无系统音量适配。")


def application(number):
    number = int(float(number)) - 1
    names = {
        "Windows": ["notepad", "winword", "excel", "powerpnt", "cmd", "msedge"],
        "Darwin": ["TextEdit", "Pages", "Numbers", "Keynote", "Terminal", "Safari"],
        "Linux": ["gedit", "libreoffice", "libreoffice", "libreoffice", "x-terminal-emulator", "xdg-open"],
    }
    system = platform.system()
    name = names[system][number]
    if system == "Darwin":
        subprocess.run(["open", "-a", name], check=True)
    elif system == "Windows":
        if number == 5:
            os.startfile("https://praat.org")
        else:
            # ShellExecute resolves Windows App Paths such as winword.exe.
            import ctypes
            result = ctypes.windll.shell32.ShellExecuteW(None, "open", name, None, None, 1)
            if result <= 32:
                raise ValueError(f"未找到 {name}，请安装相应程序。")
    else:
        candidates = [name]
        if number == 0:
            candidates += ["gnome-text-editor", "mousepad", "kate", "xed"]
        if number == 4:
            candidates += ["gnome-terminal", "konsole", "xterm"]
        found = next((shutil.which(n) for n in candidates if shutil.which(n)), None)
        if not found:
            raise ValueError("未找到相应应用，请安装桌面编辑器、LibreOffice 或终端。")
        args = [found]
        if number in (1, 2, 3):
            args += [{1: "--writer", 2: "--calc", 3: "--impress"}[number]]
        if number == 5:
            args += ["https://praat.org"]
        subprocess.Popen(args)


def main():
    operation, *args = sys.argv[1:]
    if operation == "capture":
        run_capture(args)
    elif operation == "volume":
        volume(*args)
    elif operation == "application":
        application(*args)
    else:
        raise ValueError("未知操作。")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, RuntimeError, OSError, subprocess.CalledProcessError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
