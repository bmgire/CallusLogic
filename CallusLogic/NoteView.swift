//  Copyright © 2016 Gire. All rights reserved.
//  NoteView and Controller for the NoteView objects in the FretboardView.


import Cocoa

class NoteView: NSView {
    
    //##########################################################
    // MARK: - Constants
    //##########################################################
    
    let chromaticColor = NSColor.redColor()
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    

    
//    // The display mode is read from the fretboard Calculator, determines which note display mode to use.
//    private var displayMode = ""

    private var noteModel = NoteModel()
    
    // Indicates whether the button has been pressed successfully.
    private var pressed: Bool = false
    
    //private var noteColor = NSColor.yellowColor()

    // Variable to hold this notes BezierPath.
    private var path: NSBezierPath?
    
    // The rect for the NoteView.
    private var noteRect: CGRect?
    
    //##########################################################
    // Bools
    //##########################################################
    
    //##########################################################
    // MARK: - getters and setters.
    //##########################################################
    func getNoteModel() -> NoteModel {
        return noteModel
    }
    
    func setNoteModel(newModel: NoteModel){
        noteModel = newModel
        needsDisplay = true
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
        
        if noteModel.getCanCustomize() {
            //Swift.print("mouseUp clickCount: \(theEvent.clickCount)")
            if pressed {
               
                    // if myColor hasn't been updated to the new userColor, redraw.
                 if noteModel.doesMyColorEqualUserColor() == false {
                        // and if it isn't ghosted, just changed the color, don't ghost.
                        if noteModel.getIsGhost() == true {
                            
                            noteModel.setIsGhost(!noteModel.getIsGhost())
                        }
                    }
                    // Else, the colors are the same, turn unselected notes into selected notes, and vice versa.
                    else {
                        noteModel.setIsGhost(!noteModel.getIsGhost())
                    }
            
            }
            pressed = false
            needsDisplay = true
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
    // MARK: - Custom functions
    //##########################################################
    
    // Draws the note or number
    private func drawNote() {
        if noteModel.getIsDisplayed() == true{
            // Assigns a value to the noteRect.
            noteRect = bounds.insetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05)
            
            // Defines the radius of the corners of a rounded rect.
            let cornerRadius = bounds.size.height * 0.2
            
            // Assign a value to the path.
            path = NSBezierPath(roundedRect: noteRect!, xRadius: cornerRadius , yRadius: cornerRadius)
            
            
            
            // If not in the scale, use the chromatic color.
            if noteModel.getIsInScale() == false {
                noteModel.setMyColor(chromaticColor)
            }
            //     Else use the userColor.
            else {
                noteModel.setMyColor(noteModel.getUserColor())
            }

        
            
            // If appropriate, set alpha to ghosting transparency
            if noteModel.getIsGhost() == true {
                noteModel.setMyColor(noteModel.getMyColor().colorWithAlphaComponent(CGFloat(0.1)))
            }
            else {
                noteModel.setMyColor(noteModel.getMyColor().colorWithAlphaComponent(CGFloat(1)))
            }
            
            // Set color and fill.
            
            noteModel.getMyColor().set()
            path?.fill()
            
            // Create an NSParagraphStyle object
            let paraStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
            
            // Set orientation.
            paraStyle.alignment = .Right
            
            // definte a font.
            let font = NSFont.systemFontOfSize(noteModel.getNoteFontSize())
            
            // Attributes for drawing.
            let attrs = [
                NSForegroundColorAttributeName: NSColor.blackColor(),
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paraStyle]
            
            // Define an attributed string set to display the note.
            var attributedNote = NSMutableAttributedString()
            
            // Choose which displayMode mode to use.
            if noteModel.getDisplayMode() == "Notes"
            {
                attributedNote = NSMutableAttributedString(string: noteModel.getNote(), attributes: attrs)
            }
            if noteModel.getDisplayMode() == "Numbers 0-11"
            {
                attributedNote = NSMutableAttributedString(string: noteModel.getNumber0to11(), attributes: attrs)
            }
                
            else if noteModel.getDisplayMode() == "Numbers 0-46"
            {
                attributedNote = NSMutableAttributedString(string: noteModel.getNumber0to46(), attributes: attrs)
            }
            else if noteModel.getDisplayMode() == "Intervals"
            {
                attributedNote = NSMutableAttributedString(string: noteModel.getInterval(), attributes: attrs)
            }
            
            // Draw using custom NSString drawing function defined in NSString+drawing.swift.
            attributedNote.drawCenterCustomInRect(bounds, withAttributes: attrs)
        }
    }
}
