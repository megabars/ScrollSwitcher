# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ScrollSwitcher is a macOS menu bar utility that toggles the scroll direction (natural/standard) via a status bar popover. It runs as an accessory app (no Dock icon).

## Build & Run

```bash
cd ScrollSwitcher
./build.sh              # builds to build/ScrollSwitcher.app
open build/ScrollSwitcher.app
```

Build uses `swiftc` directly (no Xcode project). Targets arm64 macOS 13.0+. Ad-hoc code signing preserves Accessibility permissions between rebuilds.

## Architecture

Three Swift source files in `ScrollSwitcher/ScrollSwitcher/`:

- **ScrollSwitcherApp.swift** — `@main` entry point, sets `.accessory` activation policy (hides from Dock)
- **AppDelegate.swift** — `ScrollToggler` singleton accesses private `PreferencePanesSupport` framework via `dlopen`/`dlsym` to read/write the system scroll direction. `AppDelegate` manages the `NSStatusItem` and `NSPopover`.
- **ContentView.swift** — SwiftUI view with a toggle bound to `ScrollToggler.shared` state and a quit button

The private framework interaction uses C function pointers (`swipeScrollDirection` / `setSwipeScrollDirection`) resolved at runtime — this is the core mechanism and the most fragile part of the codebase.

## Dependencies

No external dependencies. Uses only Cocoa, SwiftUI, and the private PreferencePanesSupport framework.
