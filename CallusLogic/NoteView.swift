//
//  NoteView.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 4/22/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class NoteView: NSView {
    
    
    ///////////////////////////////////////////////////////////////////////////
    // Variables
    ///////////////////////////////////////////////////////////////////////////
    
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
    
    // The associated note number.
    var number0to11: String = "0" {
        didSet {
            needsDisplay = true
        }
    }
    
    var number0to46: String = "0" {
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
    var isYellow: Bool = true
    
    // Variable to hold this notes BezierPath.
    var path: NSBezierPath?
    
    var noteRect: CGRect?
    
    ///////////////////////////////////////////////////////////////////////////
    // Draws the rect.
    ///////////////////////////////////////////////////////////////////////////
    override func drawRect(dirtyRect: CGRect) {
        drawNote()
        needsDisplay = false
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // Draws the note or number
    ///////////////////////////////////////////////////////////////////////////
    func drawNote() {
        
        // define noteFrame.
     //   let drawingBounds = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
       // let padding =
        
       // Attempting to update the 
        
        noteRect = bounds.insetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05)
        
        // set path
        let cornerRadius = bounds.size.height * 0.2
        path = NSBezierPath(roundedRect: noteRect!, xRadius: cornerRadius , yRadius: cornerRadius)
        
        //  To be used the with creating custom keyboards maps.
        //  NSColor(calibratedRed: 1.0, green: 1.0, blue: 0, alpha: 0.8).set()
        
        // If changeColor is set and the current color is yellow, change to blue, else (to both of the first to if statements
        
            //myColor = NSColor.yellowColor()
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
        
        myColor.set()
        path?.fill()
        

        // Create a NSMutableAttributedString and draw.
        
        let paraStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paraStyle.alignment = .Right
        
        
            
        

        let font = NSFont.systemFontOfSize(noteFont)
        let attrs = [
            NSForegroundColorAttributeName: NSColor.blackColor(),
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paraStyle]
            
        var attributedNote = NSMutableAttributedString(string: note, attributes: attrs)
        
        //If fretDisplay isn't set to Notes display the appropriate notes.
        if fretDisplay == "Numbers 0-11"
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
        
        //let string = "\(note)" as NSString
        attributedNote.drawCenterCustomInRect(bounds, withAttributes: attrs) //, font: noteFont)
        
    }
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    // Adds parenthesis to passing note.
    ///////////////////////////////////////////////////////////////////////////
    func addParenthesis() {
        var temp = "("
        temp.appendContentsOf(note)
        temp.appendContentsOf(")")
        note = temp
    }
    
    func changeNote(newNote: String) {
        note = newNote
        needsDisplay = true
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // MARK: - Mouse Events
    ///////////////////////////////////////////////////////////////////////////
    override func mouseDown(theEvent: NSEvent) {
        Swift.print("mouseDown")
        
        // Get the frame of the die.
        // let dieFrame = metricsForSize(bounds.size).dieFrame        // Old Version. only frame of view.
        
        
        //Converts the locationInWindow to the views coorinate system.
        // Passing nil as the funcs view argument results in converting to/from the view's window.
        
        
        // OLD VERSION
        // Note theEvent.locationInWindow = the click inside the note.
        
     //   let hitPoint = theEvent.locationInWindow
        
        // Convert the hitPoint to the rotated stringView.
        
        let pointInView = convertPoint(theEvent.locationInWindow, fromView: nil)

        
        // limits pressed test to within die's BezierPath.
        pressed = path!.containsPoint(pointInView)
    }
    

    



    override func mouseUp(theEvent: NSEvent) {
        Swift.print("mouseUp clickCount: \(theEvent.clickCount)")

            if pressed {
             changeColor = true
            }
        pressed = false
    //    }
    }

    
    ///////////////////////////////////////////////////////////////////////////
    // Keyboard Event handling.
    ///////////////////////////////////////////////////////////////////////////
    
    // MARK: - First Responder
    override var acceptsFirstResponder: Bool { return true }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
//    
//    
//    override func drawFocusRingMask() {
//        NSBezierPath.fillRect(bounds)
//    }
//    
//    override var focusRingMaskBounds: CGRect {
//        return bounds
//    }

    // MARK: - KeyBoard Events
    override func keyDown(theEvent:NSEvent) {
        interpretKeyEvents([theEvent])
    }
//
//    // Insert text
//    override func insertText(insertString: AnyObject) {
//        // Store new text into note var.
//        note = insertString as! String
//    }
//    
//    
    // Tab functions.
    override func insertTab(sender: AnyObject?) {
        window?.selectNextKeyView(sender)
    }
    
    override func insertBacktab(sender: AnyObject?) {
        window?.selectPreviousKeyView(sender)
    }
    
}
