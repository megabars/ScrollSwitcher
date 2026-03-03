#!/bin/bash
set -e

APP_NAME="ScrollSwitcher"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS="${APP_BUNDLE}/Contents"
MACOS="${CONTENTS}/MacOS"
RESOURCES="${CONTENTS}/Resources"
SOURCES="ScrollSwitcher/*.swift"
SDK=$(xcrun --show-sdk-path)

echo "Building ${APP_NAME}..."

rm -rf "${BUILD_DIR}"
mkdir -p "${MACOS}" "${RESOURCES}"

# Generate icon (host arch)
swiftc -sdk "$SDK" -o "${BUILD_DIR}/generate_icon" generate_icon.swift
./"${BUILD_DIR}/generate_icon"

# Compile for arm64
swiftc \
    -target arm64-apple-macos13.0 \
    -sdk "$SDK" \
    -o "${BUILD_DIR}/${APP_NAME}_arm64" \
    ${SOURCES}

# Compile for x86_64
swiftc \
    -target x86_64-apple-macos13.0 \
    -sdk "$SDK" \
    -o "${BUILD_DIR}/${APP_NAME}_x86_64" \
    ${SOURCES}

# Create universal binary
lipo -create \
    "${BUILD_DIR}/${APP_NAME}_arm64" \
    "${BUILD_DIR}/${APP_NAME}_x86_64" \
    -output "${MACOS}/${APP_NAME}"

rm "${BUILD_DIR}/${APP_NAME}_arm64" "${BUILD_DIR}/${APP_NAME}_x86_64"

# Copy Info.plist and icon
cp "ScrollSwitcher/Info.plist" "${CONTENTS}/Info.plist"
cp "${BUILD_DIR}/AppIcon.icns" "${RESOURCES}/AppIcon.icns"

# Sign the app so macOS keeps Accessibility permission between rebuilds
codesign --force --sign - --identifier "com.scrollswitcher.app" "${APP_BUNDLE}"

echo "Build complete: ${APP_BUNDLE}"
echo "Run with: open ${APP_BUNDLE}"
