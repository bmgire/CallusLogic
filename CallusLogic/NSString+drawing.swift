//
//  NSString+drawing.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 4/24/16.
//  Copyright © 2016 Gire. All rights reserved.
//
// This extension draws the note name on the right and centered vertically. 




import Cocoa

extension NSAttributedString {

    
    func drawCenterCustomInRect(rect: NSRect, withAttributes: [String: AnyObject]?) {
        let stringSize = size()
        let point = NSPoint(x: rect.midX - stringSize.width/2,
                            y: (rect.maxY - stringSize.height)/2)
        
        drawAtPoint(point)
    }
    
    // old version
//    func drawRightCustomInRect(rect: NSRect, withAttributes: [String: AnyObject]?) {
//        let stringSize = sizeWithAttributes(withAttributes)
//        let offset = CGFloat(5.0)
//        // I'm not totally sure how this calculates the center of the view... I'd have to write out the math.
//        let point = NSPoint(x: rect.origin.x + (rect.width - stringSize.width - offset),
//                            y: ((rect.maxY) - (stringSize.height))/2)
//        
//        drawAtPoint(point, withAttributes: withAttributes)
//    }
}