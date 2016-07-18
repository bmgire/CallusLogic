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
    // MARK: - Constants
    //##########################################################
    
//    let calcedColor = NSColor.yellowColor()
    
    let chromaticColor = NSColor.redColor()
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    
    //####################
    // Note Display variables
    //####################
    
    // The note to display.
    var note: String = "" 
    
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
    
    // The interval relative to the root.
    var interval = ""

    // The display mode is read from the fretboard Calculator, determines which note display mode to use.
    var displayMode = ""

    //##########################################################
    // Drawing and customizing variables.
    //##########################################################
    
    // This variable indicates whether editing the view is allowed.
    var canCustomize = false
    // FontSize
    var noteFont: CGFloat = 16
    
    // The user Selected Color
    var userColor = NSColor.yellowColor()
    
    // A state variable to be set while the mouse is down.
    var myColor: NSColor?
    
    var prevColor:NSColor?
    //var customColor = NSColor.yellowColor()
    
    // Variable to hold this notes BezierPath.
    var path: NSBezierPath?
    
    // The rect for the NoteView.
    var noteRect: CGRect?
    
    //##########################################################
    // Bools
    //##########################################################
    var changeColor: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    // Indicates the Color is yellow.
    var isYellow: Bool = true
    
    // Enables and disables ghosting.
    var isGhost = false {
        didSet {
            needsDisplay = true
        }
    }

    // Indicates whether the button has been pressed successfully.
    var pressed: Bool = false //{
    
    // Indicates the note is in the calculated scale.
    var isInScale = false
    
    // Indicates the note should be kept.
    var isKept = false
    
    // Indicates whether note is diplayed.
    var isDisplayed = false {
        didSet {
            if isDisplayed == true {
                hidden = false
            }
            else {
                hidden = true
            }
        }
    }
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
        //Swift.print("mouseDown")  
        
        //Converts the locationInWindow to the views coorinate system.
        let pointInView = convertPoint(theEvent.locationInWindow, fromView: nil)
        
        // tests if we pressed into this view.
        pressed = path!.containsPoint(pointInView)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        
        if canCustomize {
            //Swift.print("mouseUp clickCount: \(theEvent.clickCount)")
            if pressed {
                if canCustomize == true {
                    // if myColor hasn't been updated to the new userColor, redraw.
                    if userColor != myColor {
                        // and if it isn't ghosted, just changed the color.
                        if isGhost == false {
                            
                            needsDisplay = true
                        }
                        // if ghosted, just ghost with new color.
                        else {
                            isGhost = !isGhost
                        }
                    }
                    // Else, the colors are the same, turn unselected notes into selected notes, and vice versa.
                    else {
                        isGhost = !isGhost
                    }
                }
            }
            pressed = false
        }
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
        
//        // If changeColor is true: and the current color is yellow, change myColor to blue... else change myColor yellow.
//        // Else ChangeColor is false, change nothing.
//            if changeColor {
//                if isYellow {
//                    myColor = NSColor(calibratedRed: 0.0, green: 0.55, blue: 1.0, alpha: 1)
//                    isYellow = false
//                }
//                else {
//                    myColor = NSColor.yellowColor()
//                    isYellow = true
//                }
//            }
        
        // If the note is not part of the scale set the color to chromatic filler notes.
        
//        if useCustomColor == true {
//            myColor = customColor
//        }
        
        if isInScale == false {
            myColor = chromaticColor
        }
        else {
            myColor = userColor
        }
        
        // If appropriate, set alpha to ghosting transparency
        if isGhost == true {
            myColor = myColor!.colorWithAlphaComponent(CGFloat(0.1))
        }
        else {
            myColor = myColor!.colorWithAlphaComponent(CGFloat(1))
        }
        
        // Set color and fill.
        myColor!.set()
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
        
       
        // Choose which displayMode mode to use.
        if displayMode == "Notes"
        {
            attributedNote = NSMutableAttributedString(string: note, attributes: attrs)
        }
        else if displayMode == "Numbers 0-11"
        {
            attributedNote = NSMutableAttributedString(string: number0to11, attributes: attrs)
        }
        
        else if displayMode == "Numbers 0-46"
        {
            attributedNote = NSMutableAttributedString(string: number0to46, attributes: attrs)
        }
        else if displayMode == "Intervals"
        {
            attributedNote = NSMutableAttributedString(string: interval, attributes: attrs)
        }
        
        // Draw using custom NSString drawing function defined in NSString+drawing.swift.
        attributedNote.drawCenterCustomInRect(bounds, withAttributes: attrs)
    }
}
