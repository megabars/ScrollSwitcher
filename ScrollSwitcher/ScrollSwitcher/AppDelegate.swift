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

    private func createMenuBarIcon() -> NSImage {
        let size: CGFloat = 18
        let img = NSImage(size: NSSize(width: size, height: size))
        img.lockFocus()

        let ctx = NSGraphicsContext.current!.cgContext

        // Trackpad body
        let padRect = CGRect(x: 1, y: 1, width: 16, height: 16)
        let padPath = CGPath(roundedRect: padRect, cornerWidth: 3, cornerHeight: 3, transform: nil)
        ctx.setStrokeColor(NSColor.controlTextColor.cgColor)
        ctx.setLineWidth(1.2)
        ctx.addPath(padPath)
        ctx.strokePath()

        // Divider line (click area)
        ctx.move(to: CGPoint(x: 4, y: 5))
        ctx.addLine(to: CGPoint(x: 14, y: 5))
        ctx.setLineWidth(0.8)
        ctx.strokePath()

        // Up arrow
        ctx.setFillColor(NSColor.controlTextColor.cgColor)
        ctx.move(to: CGPoint(x: 9, y: 15))
        ctx.addLine(to: CGPoint(x: 6, y: 11.5))
        ctx.addLine(to: CGPoint(x: 12, y: 11.5))
        ctx.closePath()
        ctx.fillPath()

        // Down arrow
        ctx.move(to: CGPoint(x: 9, y: 6.5))
        ctx.addLine(to: CGPoint(x: 6, y: 10))
        ctx.addLine(to: CGPoint(x: 12, y: 10))
        ctx.closePath()
        ctx.fillPath()

        img.unlockFocus()
        img.isTemplate = true
        return img
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = createMenuBarIcon()
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
