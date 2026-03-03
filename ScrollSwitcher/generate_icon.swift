import Cocoa

// Generate a skeuomorphic trackpad icon with scroll arrows
func generateIcon(size: Int) -> NSImage {
    let s = CGFloat(size)
    let img = NSImage(size: NSSize(width: s, height: s))
    img.lockFocus()

    let ctx = NSGraphicsContext.current!.cgContext

    // --- Background: rounded rect (macOS icon shape) ---
    let iconRect = CGRect(x: s * 0.05, y: s * 0.05, width: s * 0.9, height: s * 0.9)
    let cornerRadius = s * 0.22
    let bgPath = CGPath(roundedRect: iconRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)

    // Gradient background (dark gray to lighter gray, like a trackpad)
    ctx.saveGState()
    ctx.addPath(bgPath)
    ctx.clip()
    let bgColors = [
        CGColor(red: 0.75, green: 0.75, blue: 0.78, alpha: 1.0),
        CGColor(red: 0.88, green: 0.88, blue: 0.90, alpha: 1.0),
    ]
    let bgGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: bgColors as CFArray, locations: [0.0, 1.0])!
    ctx.drawLinearGradient(bgGradient, start: CGPoint(x: s/2, y: s * 0.05), end: CGPoint(x: s/2, y: s * 0.95), options: [])
    ctx.restoreGState()

    // Border
    ctx.saveGState()
    ctx.addPath(bgPath)
    ctx.setStrokeColor(CGColor(red: 0.55, green: 0.55, blue: 0.58, alpha: 1.0))
    ctx.setLineWidth(s * 0.02)
    ctx.strokePath()
    ctx.restoreGState()

    // --- Trackpad surface (inner rounded rect) ---
    let padRect = CGRect(x: s * 0.15, y: s * 0.20, width: s * 0.70, height: s * 0.65)
    let padRadius = s * 0.10
    let padPath = CGPath(roundedRect: padRect, cornerWidth: padRadius, cornerHeight: padRadius, transform: nil)

    ctx.saveGState()
    ctx.addPath(padPath)
    ctx.clip()
    let padColors = [
        CGColor(red: 0.92, green: 0.92, blue: 0.94, alpha: 1.0),
        CGColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0),
    ]
    let padGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: padColors as CFArray, locations: [0.0, 1.0])!
    ctx.drawLinearGradient(padGradient, start: CGPoint(x: s/2, y: s * 0.20), end: CGPoint(x: s/2, y: s * 0.85), options: [])
    ctx.restoreGState()

    // Pad border
    ctx.saveGState()
    ctx.addPath(padPath)
    ctx.setStrokeColor(CGColor(red: 0.65, green: 0.65, blue: 0.68, alpha: 1.0))
    ctx.setLineWidth(s * 0.015)
    ctx.strokePath()
    ctx.restoreGState()

    // --- Up arrow ---
    let arrowWidth = s * 0.18
    let arrowHeight = s * 0.12
    let centerX = s * 0.5
    let upCenterY = s * 0.62

    ctx.saveGState()
    ctx.setFillColor(CGColor(red: 0.20, green: 0.45, blue: 0.85, alpha: 1.0))
    ctx.move(to: CGPoint(x: centerX, y: upCenterY + arrowHeight / 2))
    ctx.addLine(to: CGPoint(x: centerX - arrowWidth / 2, y: upCenterY - arrowHeight / 2))
    ctx.addLine(to: CGPoint(x: centerX + arrowWidth / 2, y: upCenterY - arrowHeight / 2))
    ctx.closePath()
    ctx.fillPath()
    ctx.restoreGState()

    // --- Down arrow ---
    let downCenterY = s * 0.42

    ctx.saveGState()
    ctx.setFillColor(CGColor(red: 0.20, green: 0.45, blue: 0.85, alpha: 1.0))
    ctx.move(to: CGPoint(x: centerX, y: downCenterY - arrowHeight / 2))
    ctx.addLine(to: CGPoint(x: centerX - arrowWidth / 2, y: downCenterY + arrowHeight / 2))
    ctx.addLine(to: CGPoint(x: centerX + arrowWidth / 2, y: downCenterY + arrowHeight / 2))
    ctx.closePath()
    ctx.fillPath()
    ctx.restoreGState()

    // --- Bottom bar (trackpad click area divider) ---
    ctx.saveGState()
    ctx.setStrokeColor(CGColor(red: 0.70, green: 0.70, blue: 0.73, alpha: 0.6))
    ctx.setLineWidth(s * 0.01)
    ctx.move(to: CGPoint(x: s * 0.22, y: s * 0.30))
    ctx.addLine(to: CGPoint(x: s * 0.78, y: s * 0.30))
    ctx.strokePath()
    ctx.restoreGState()

    img.unlockFocus()
    return img
}

func saveIconSet() {
    let sizes = [16, 32, 64, 128, 256, 512, 1024]
    let buildDir = "build"

    // Create iconset directory
    let iconsetPath = "\(buildDir)/AppIcon.iconset"
    try? FileManager.default.createDirectory(atPath: iconsetPath, withIntermediateDirectories: true)

    for size in sizes {
        let img = generateIcon(size: size)
        guard let tiff = img.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff),
              let png = rep.representation(using: .png, properties: [:]) else { continue }

        // Standard resolution
        if size <= 512 {
            let filename = "icon_\(size)x\(size).png"
            try? png.write(to: URL(fileURLWithPath: "\(iconsetPath)/\(filename)"))
        }

        // @2x resolution (e.g., 1024 = 512@2x, 512 = 256@2x, etc.)
        let halfSize = size / 2
        if halfSize >= 16 {
            let filename2x = "icon_\(halfSize)x\(halfSize)@2x.png"
            try? png.write(to: URL(fileURLWithPath: "\(iconsetPath)/\(filename2x)"))
        }
    }

    // Convert to .icns
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
    process.arguments = ["-c", "icns", iconsetPath, "-o", "\(buildDir)/AppIcon.icns"]
    try? process.run()
    process.waitUntilExit()

    if process.terminationStatus == 0 {
        print("Icon created: \(buildDir)/AppIcon.icns")
        // Clean up iconset
        try? FileManager.default.removeItem(atPath: iconsetPath)
    } else {
        print("Error creating .icns file")
    }
}

saveIconSet()
