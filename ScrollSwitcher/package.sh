#!/bin/bash
set -e

APP_NAME="ScrollSwitcher"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
DMG_DIR="${BUILD_DIR}/dmg"
DMG_PATH="${BUILD_DIR}/${APP_NAME}.dmg"

# Сначала собираем приложение
./build.sh

echo "Packaging ${APP_NAME}.dmg..."

# Подготовка папки для DMG
rm -rf "${DMG_DIR}"
mkdir -p "${DMG_DIR}"
cp -R "${APP_BUNDLE}" "${DMG_DIR}/"
ln -s /Applications "${DMG_DIR}/Applications"

# Создание DMG
rm -f "${DMG_PATH}"
hdiutil create -volname "${APP_NAME}" \
    -srcfolder "${DMG_DIR}" \
    -ov -format UDZO \
    "${DMG_PATH}"

rm -rf "${DMG_DIR}"

echo "Done: ${DMG_PATH}"
echo "Размер: $(du -h "${DMG_PATH}" | cut -f1)"
