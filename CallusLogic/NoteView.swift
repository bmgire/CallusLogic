//
//  NoteView.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 4/22/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class NoteView: NSView {
    
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    
    // The note to display.
    var note: String = "" {
        didSet {
            if note == ""{
            hidden = true
            }
            else {
                hidden = false
                needsDisplay = true
                changeColor = false
            }
        }
    }
    
    // The associated note number in base 12.
    var number0to11: String = "" {
        didSet {
            needsDisplay = true
        }
    }
    
    // The associated note number in where every distinct tone on
    // the fretboard is numbered.
    var number0to46: String = "" {
        didSet {
            needsDisplay = true
        }
    }
    
    var interval = ""
    
    var fretDisplay = ""
    
    // FontSize
    var noteFont: CGFloat = 16
    
    // A state variable to be set while the mouse is down.
    var pressed: Bool = false //{

    var myColor: NSColor = NSColor.yellowColor()
    var changeColor: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    // Indicates the Color is yellow.
    var isYellow: Bool = true
    
    // Variable to hold this notes BezierPath.
    var path: NSBezierPath?
    
    // The rect for the NoteView.
    var noteRect: CGRect?
    
    //##########################################################
    // MARK: - Overridden functions
    //##########################################################
    override func drawRect(dirtyRect: CGRect) {
        drawNote()
        needsDisplay = false
    }
    
    //##########################################################
    // MARK: - Mouse Events
    //##########################################################
    
    override func mouseDown(theEvent: NSEvent) {
        Swift.print("mouseDown")
        
        //Converts the locationInWindow to the views coorinate system.
        let pointInView = convertPoint(theEvent.locationInWindow, fromView: nil)
        
        // tests if we pressed into this view.
        pressed = path!.containsPoint(pointInView)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        Swift.print("mouseUp clickCount: \(theEvent.clickCount)")
        if pressed {
            changeColor = true
        }
        pressed = false
    }
    
    
    ///////////////////////////////////////////////////////////////////////////
    // Keyboard Event handling.
    ///////////////////////////////////////////////////////////////////////////
    
    //##########################################################
    // MARK: - First Responder
    //##########################################################
    
    override var acceptsFirstResponder: Bool { return true }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    //##########################################################
    // MARK: - KeyboardEvents
    //##########################################################
    override func keyDown(theEvent:NSEvent) {
        interpretKeyEvents([theEvent])
    }
    
    // Tab functions.
    override func insertTab(sender: AnyObject?) {
        window?.selectNextKeyView(sender)
    }
    
    override func insertBacktab(sender: AnyObject?) {
        window?.selectPreviousKeyView(sender)
    }
    
    //##########################################################
    // MARK: - Custom functions
    //##########################################################
    
    // Draws the note or number
    func drawNote() {
        
        // Assigns a value to the noteRect.
        noteRect = bounds.insetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05)
        
        // Defines the radius of the corners of a rounded rect.
        let cornerRadius = bounds.size.height * 0.2
        
        // Assign a value to the path.
        path = NSBezierPath(roundedRect: noteRect!, xRadius: cornerRadius , yRadius: cornerRadius)
        
        // If changeColor is true: and the current color is yellow, change myColor to blue... else change myColor yellow.
        // Else ChangeColor is false, change nothing.
            if changeColor {
                if isYellow {
                    myColor = NSColor(calibratedRed: 0.0, green: 0.55, blue: 1.0, alpha: 1)
                    isYellow = false
                }
                else {
                    myColor = NSColor.yellowColor()
                    isYellow = true
                }
            }
        // Set color and fill.
        myColor.set()
        path?.fill()
        
        // Create an NSParagraphStyle object
        let paraStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        
        // Set orientation.
        paraStyle.alignment = .Right
    
        // definte a font.
        let font = NSFont.systemFontOfSize(noteFont)
        
        // Attributes for drawing.
        let attrs = [
            NSForegroundColorAttributeName: NSColor.blackColor(),
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paraStyle]
        
        // Define an attributed string set to display the note.
        var attributedNote = NSMutableAttributedString()
        
       
        // Choose which fretDisplay mode to use.
        if fretDisplay == "Notes"
        {
            attributedNote = NSMutableAttributedString(string: note, attributes: attrs)
        }
        else if fretDisplay == "Numbers 0-11"
        {
            attributedNote = NSMutableAttributedString(string: number0to11, attributes: attrs)
        }
        
        else if fretDisplay == "Numbers 0-46"
        {
            attributedNote = NSMutableAttributedString(string: number0to46, attributes: attrs)
        }
        else if fretDisplay == "Intervals"
        {
            attributedNote = NSMutableAttributedString(string: interval, attributes: attrs)
        }
        
        // Draw using custom NSString drawing function defined in NSString+drawing.swift.
        attributedNote.drawCenterCustomInRect(bounds, withAttributes: attrs)
    }
}
