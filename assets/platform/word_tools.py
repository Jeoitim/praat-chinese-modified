"""Portable counterpart to the supplied Windows segmentation tool.

Original workflow: 贝先明、向柠. This implementation: jeoitim.
Dependencies remain optional and are installed by the user.
"""
import collections
import csv
import sys
import os
import tempfile
from pathlib import Path


def analyse(text, tokenize):
    return collections.Counter((item.word, item.flag) for item in tokenize(text) if item.word.strip())


def main():
    source, target, order, cloud, font = sys.argv[1:]
    try:
        import jieba.posseg
    except ImportError as error:
        raise RuntimeError("自动分词需要 jieba，请在已配置的 Python 环境中安装：python -m pip install jieba") from error
    raw = Path(source).read_bytes()
    text = raw.decode("utf-16") if raw.startswith((b"\xff\xfe", b"\xfe\xff")) else raw.decode("utf-8-sig")
    counts = analyse(text, jieba.posseg.cut)
    rows = sorted(counts.items(), key=(lambda item: (-item[1], item[0])) if int(float(order)) == 1 else (lambda item: (item[0][1], -item[1], item[0][0])))
    target = Path(target)
    cloud_path = target.with_suffix(".png")
    if target.exists() or (int(float(cloud)) and cloud_path.exists()):
        raise ValueError("结果文件已存在，请换一个文件名。")
    image = None
    if int(float(cloud)):
        if not font or not Path(font).is_file():
            raise ValueError("词云需要指定支持中文的字体文件；随包 Doulos SIL 为国际音标字体。")
        cache = tempfile.TemporaryDirectory(prefix="praat_wordcloud_cache_", ignore_cleanup_errors=True)
        os.environ.setdefault("MPLCONFIGDIR", cache.name)
        try:
            from wordcloud import WordCloud
        except ImportError as error:
            raise RuntimeError("词云需要 wordcloud 与 Pillow：python -m pip install wordcloud Pillow") from error
        totals = collections.Counter()
        for (word, tag), count in counts.items():
            totals[word] += count
        image = WordCloud(font_path=font, width=1200, height=800, background_color="white").generate_from_frequencies(totals)
    with target.open("w", encoding="utf-8", newline="") as file:
        writer = csv.writer(file, delimiter="\t", lineterminator="\n")
        writer.writerow(["内容", "词性", "词数"])
        writer.writerows((word, tag, count) for ((word, tag), count) in rows)
    if image:
        image.to_file(str(cloud_path))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, RuntimeError, OSError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
