//  Copyright © 2016 Gire. All rights reserved.
// This extension draws the note name on the right and centered vertically. 

import Cocoa

extension NSAttributedString {

    func drawCenterCustomInRect(rect: NSRect, withAttributes: [String: AnyObject]?) {
        let stringSize = size()
        let point = NSPoint(x: rect.midX - stringSize.width/2,
                            y: (rect.maxY - stringSize.height)/2)
        
        drawAtPoint(point)
    }
}