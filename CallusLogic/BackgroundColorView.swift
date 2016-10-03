//  Copyright © 2016 Gire. All rights reserved.
//  Sets the background color for the app.

import Cocoa

class BackgroundColorView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let backgroundColor = NSColor(calibratedRed: 1.0, green: 0.8, blue: 0.0, alpha: 0.3)
        backgroundColor.set()
        NSBezierPath.fill(bounds)
    }
    
}
