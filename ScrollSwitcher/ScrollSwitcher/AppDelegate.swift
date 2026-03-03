import Cocoa
import SwiftUI

class ScrollToggler {
    static let shared = ScrollToggler()

    private typealias GetFn = @convention(c) () -> Bool
    private typealias SetFn = @convention(c) (Bool) -> Void

    private let handle: UnsafeMutableRawPointer?
    private let getFn: GetFn?
    private let setFn: SetFn?

    private init() {
        handle = dlopen("/System/Library/PrivateFrameworks/PreferencePanesSupport.framework/PreferencePanesSupport", RTLD_LAZY)
        if let handle = handle,
           let getPtr = dlsym(handle, "swipeScrollDirection"),
           let setPtr = dlsym(handle, "setSwipeScrollDirection") {
            getFn = unsafeBitCast(getPtr, to: GetFn.self)
            setFn = unsafeBitCast(setPtr, to: SetFn.self)
        } else {
            getFn = nil
            setFn = nil
            NSLog("ScrollToggler: failed to load PreferencePanesSupport")
        }
    }

    var isNaturalScroll: Bool {
        get { getFn?() ?? true }
        set { setFn?(newValue) }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "arrow.up.arrow.down", accessibilityDescription: "Scroll Switcher")
            button.action = #selector(togglePopover)
            button.target = self
        }

        popover = NSPopover()
        popover.contentSize = NSSize(width: 220, height: 120)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    @objc func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            NSApp.activate(ignoringOtherApps: true)
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
