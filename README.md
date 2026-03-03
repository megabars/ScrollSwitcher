# ScrollSwitcher

A macOS menu bar utility to quickly toggle scroll direction (natural/standard) without opening System Settings.

## Features

- Toggle scroll direction with a single click
- Lives in the menu bar, no Dock icon
- Shows current scroll state

## Requirements

- macOS 13.0+ (Ventura or later)
- Apple Silicon (arm64)

## Build & Run

```bash
cd ScrollSwitcher
./build.sh
open build/ScrollSwitcher.app
```

To package as a DMG for distribution:

```bash
./package.sh
```

## Permissions

On first launch, macOS will ask for Accessibility permission. This is required to change the system scroll direction setting.

**System Settings → Privacy & Security → Accessibility** — add ScrollSwitcher to the list.

## How It Works

The app dynamically loads Apple's private `PreferencePanesSupport` framework via `dlopen` at runtime and uses the `swipeScrollDirection` / `setSwipeScrollDirection` functions to read and change the system scroll direction.

## Credits

Built with the help of [Claude](https://claude.ai) AI by Anthropic.

---

# ScrollSwitcher (RU)

Утилита для macOS, которая позволяет быстро переключать направление прокрутки (естественная/стандартная) прямо из строки меню — без необходимости заходить в Системные настройки.

## Возможности

- Переключение направления прокрутки в один клик
- Живёт в строке меню, не занимает место в Dock
- Отображает текущее состояние прокрутки

## Требования

- macOS 13.0+ (Ventura и новее)
- Apple Silicon (arm64)

## Сборка и запуск

```bash
cd ScrollSwitcher
./build.sh
open build/ScrollSwitcher.app
```

Для упаковки в DMG:

```bash
./package.sh
```

## Разрешения

При первом запуске macOS запросит разрешение на Универсальный доступ (Accessibility). Это необходимо для изменения системных настроек прокрутки.

**Системные настройки → Конфиденциальность и безопасность → Универсальный доступ** — добавьте ScrollSwitcher в список.

## Как это работает

Приложение использует приватный фреймворк Apple `PreferencePanesSupport`, загружая его через `dlopen` во время выполнения. Через функции `swipeScrollDirection` и `setSwipeScrollDirection` читается и изменяется системная настройка направления прокрутки.

## Благодарности

Приложение создано при помощи нейросети [Claude](https://claude.ai) от Anthropic.
