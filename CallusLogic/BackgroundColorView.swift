//
//  BackgroundColor.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 6/28/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class BackgroundColorView: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let backgroundColor = NSColor(calibratedRed: 0.0, green: 1.0, blue: 0, alpha: 0.3)
        backgroundColor.set()
        NSBezierPath.fillRect(bounds)
    }
    
}
