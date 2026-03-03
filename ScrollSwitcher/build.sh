#!/bin/bash
set -e

APP_NAME="ScrollSwitcher"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS="${APP_BUNDLE}/Contents"
MACOS="${CONTENTS}/MacOS"
SOURCES="ScrollSwitcher/*.swift"

echo "Building ${APP_NAME}..."

rm -rf "${BUILD_DIR}"
mkdir -p "${MACOS}"

# Compile
swiftc \
    -target arm64-apple-macos13.0 \
    -sdk $(xcrun --show-sdk-path) \
    -o "${MACOS}/${APP_NAME}" \
    ${SOURCES}

# Copy Info.plist
cp "ScrollSwitcher/Info.plist" "${CONTENTS}/Info.plist"

# Sign the app so macOS keeps Accessibility permission between rebuilds
codesign --force --sign - --identifier "com.scrollswitcher.app" "${APP_BUNDLE}"

echo "Build complete: ${APP_BUNDLE}"
echo "Run with: open ${APP_BUNDLE}"
