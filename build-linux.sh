#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
jobs="${JOBS:-4}"
make PRAAT_OS=linux PRAAT_ARCH="${PRAAT_ARCH:-x64v1}" EXECUTABLE_FILE=PraatChineseModified -j"$jobs"
package="${PACKAGE_DIRECTORY:-dist/PraatChineseModified-linux-$(date +%Y%m%d-%H%M%S)}"
python3 tools/package_platform.py linux PraatChineseModified "$package"
mkdir -p build
"$package/PraatChineseModified" --utf8 --FULL-TRUST --run tests/chinese/compatibility.praat "$(pwd)/build/linux-compatibility.txt"
printf 'Package ready: %s\n' "$package"
