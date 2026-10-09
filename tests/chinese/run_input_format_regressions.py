"""Exercise historical separator formatting and exact-byte source backups."""
import argparse
import hashlib
import subprocess
import tempfile
from pathlib import Path


def literal(path):
    return '"' + str(path).replace('"', '""') + '"'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('executable', type=Path)
    executable = parser.parse_args().executable.resolve()
    runtime = executable.parent
    if runtime.name == 'MacOS':
        runtime = runtime.parent.parent.parent
    data = runtime / 'data'
    data.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='format_', dir=data) as folder:
        base = Path(folder)
        script = base / 'format.praat'
        def run(code):
            script.write_text(code, encoding='utf-8')
            result = subprocess.run([str(executable), '--utf8', '--FULL-TRUST', '--no-pref-files', '--run', str(script)],
                                    cwd=base, capture_output=True, text=True, encoding='utf-8', timeout=60)
            assert result.returncode == 0, result.stderr
        for encoding in ['utf-8', 'utf-16']:
            source = base / ('数据 空格 ' + encoding + '.txt')
            raw = 'tone  dot1\t\tdot2\n\n1    120\t130\n2\t140 150\n'.encode(encoding)
            source.write_bytes(raw)
            run('Modified format analysis text: ' + literal(source) + '\n')
            assert source.read_text(encoding='utf-8').splitlines() == ['tone\tdot1\tdot2', '1\t120\t130', '2\t140\t150']
            backup = Path(str(source) + '.before-tabs.bak')
            assert backup.read_bytes() == raw
            first = source.read_bytes()
            run('Modified format analysis text: ' + literal(source) + '\n')
            assert source.read_bytes() == first
            assert len(list(base.glob(source.name + '.before-tabs*.bak'))) == 1
            changed = 'tone dot1 dot2\n3 160 170\n'.encode('utf-8')
            source.write_bytes(changed)
            run('Modified format analysis text: ' + literal(source) + '\n')
            assert backup.read_bytes() == raw
            assert Path(str(source) + '.before-tabs.1.bak').read_bytes() == changed
        # Match the user's rule even when spaces occur inside a tab-delimited field.
        source = base / '字段内空格.txt'
        source.write_text('1\t样本 名称\t\t120\n', encoding='utf-8')
        run('Modified format analysis text: ' + literal(source) + '\n')
        assert source.read_text(encoding='utf-8').strip() == '1\t样本\t名称\t120'
        # Native text/binary Table files are never processed as delimited text.
        for command, suffix in [('Save as text file', 'text'), ('Save as binary file', 'binary')]:
            native = base / ('native_' + suffix + '.Table')
            run('Create Table with column names: "fixture", 1, "value"\nSet string value: 1, "value", "样本 名称"\n' + command + ': ' + literal(native) + '\n')
            digest = hashlib.sha256(native.read_bytes()).digest()
            run('Modified format analysis text: ' + literal(native) + '\n')
            assert hashlib.sha256(native.read_bytes()).digest() == digest
            assert not Path(str(native) + '.before-tabs.bak').exists()
        # Unwritable backup destination must fail before changing input.
        source = base / '备份失败.txt'
        source.write_text('1 120 130\n', encoding='utf-8')
        raw = source.read_bytes()
        # A nearly maximum-length basename makes the added backup suffix invalid.
        long_source = base / ('x' * 244 + '.txt')
        long_source.write_bytes(raw)
        script.write_text('Modified format analysis text: ' + literal(long_source) + '\n', encoding='utf-8')
        result = subprocess.run([str(executable), '--utf8', '--FULL-TRUST', '--no-pref-files', '--run', str(script)],
                                cwd=base, capture_output=True, timeout=60)
        assert result.returncode != 0
        assert long_source.read_bytes() == raw
    print('PASS: spaces/tabs, blank lines, Unicode encodings, idempotence, backup numbering, native Table preservation, backup failure')


if __name__ == '__main__':
    main()
