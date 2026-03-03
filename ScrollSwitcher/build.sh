#!/bin/bash
set -e

APP_NAME="ScrollSwitcher"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS="${APP_BUNDLE}/Contents"
MACOS="${CONTENTS}/MacOS"
RESOURCES="${CONTENTS}/Resources"
SOURCES="ScrollSwitcher/*.swift"

echo "Building ${APP_NAME}..."

rm -rf "${BUILD_DIR}"
mkdir -p "${MACOS}" "${RESOURCES}"

# Generate icon
swiftc -target arm64-apple-macos13.0 -sdk $(xcrun --show-sdk-path) -o "${BUILD_DIR}/generate_icon" generate_icon.swift
./"${BUILD_DIR}/generate_icon"

# Compile
swiftc \
    -target arm64-apple-macos13.0 \
    -sdk $(xcrun --show-sdk-path) \
    -o "${MACOS}/${APP_NAME}" \
    ${SOURCES}

# Copy Info.plist and icon
cp "ScrollSwitcher/Info.plist" "${CONTENTS}/Info.plist"
cp "${BUILD_DIR}/AppIcon.icns" "${RESOURCES}/AppIcon.icns"

# Sign the app so macOS keeps Accessibility permission between rebuilds
codesign --force --sign - --identifier "com.scrollswitcher.app" "${APP_BUNDLE}"

echo "Build complete: ${APP_BUNDLE}"
echo "Run with: open ${APP_BUNDLE}"
