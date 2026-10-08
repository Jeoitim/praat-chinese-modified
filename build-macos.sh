#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
python3 tools/prepare_macos.py
xcodebuild -project praat.xcodeproj -target praat_mac -configuration Configuration64 \
  SYMROOT="$PWD/build/macos/products" OBJROOT="$PWD/build/macos/intermediates" \
  ARCHS="${PRAAT_MAC_ARCHS:-arm64 x86_64}" ONLY_ACTIVE_ARCH=NO MACOSX_DEPLOYMENT_TARGET=10.15 \
  CLANG_CXX_LANGUAGE_STANDARD=gnu++17 CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" CODE_SIGN_ENTITLEMENTS="" DEVELOPMENT_TEAM="" -jobs "${JOBS:-4}" build
app="$(find build/macos/products -type d -name Praat.app -print -quit)"
test -n "$app"
package="${PACKAGE_DIRECTORY:-dist/PraatChineseModified-macos-$(date +%Y%m%d-%H%M%S).app}"
python3 tools/package_platform.py macos "$app" "$package"
mkdir -p build
"$package/Contents/MacOS/PraatChineseModified" --utf8 --FULL-TRUST --run tests/chinese/compatibility.praat "$PWD/build/macos-compatibility.txt"
printf 'Package ready: %s\n' "$package"
