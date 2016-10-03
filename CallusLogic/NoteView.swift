//  Copyright © 2016 Gire. All rights reserved.
//  NoteView and Controller for the NoteView objects in the FretboardView.


import Cocoa

class NoteView: NSView {
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    
    var viewNumberDict: [String: Int] = [:]

    fileprivate var noteModel = NoteModel()
    
    // Indicates whether the button has been pressed successfully.
    fileprivate var pressed: Bool = false
    
    // Variable to hold this notes BezierPath.
    fileprivate var path: NSBezierPath?
    
    // The rect for the NoteView.
    fileprivate var noteRect: CGRect?
    
    //##########################################################
    // MARK: - getters and setters.
    //##########################################################
    func getNoteModel() -> NoteModel {
        return noteModel
    }
    
    
    func setNoteModel(_ newModel: NoteModel){
        noteModel = newModel
        needsDisplay = true
    }
    
    
    //##########################################################
    // MARK: - Overridden functions
    //##########################################################
    
    override func draw(_ dirtyRect: CGRect) {
        drawNote()
        needsDisplay = true
    }
    
    
    //##########################################################
    // MARK: - Mouse Events
    //##########################################################
    
    override func mouseDown(with theEvent: NSEvent) {
        //Swift.print("mouseDown")   // Uncomment for debugging purposes.
        
        //Converts the locationInWindow to the views coorinate system.
        let pointInView = convert(theEvent.locationInWindow, from: nil)
        
        // tests if we pressed into this view.
        pressed = path!.contains(pointInView)
        
    }
    
    
    override func mouseUp(with theEvent: NSEvent) {
        
        if pressed {
            // Posts a notification and specifies which object sent the notification.
            NotificationCenter.default.post(name: Notification.Name(rawValue: "noteViewMouseUpEvent"), object: self, userInfo: viewNumberDict)
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
    // MARK: - Custom functions
    //##########################################################
    
    // Draws the note or number
    fileprivate func drawNote() {
        // Assigns a value to the noteRect.
        noteRect = bounds.insetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05)
        
        // Defines the radius of the corners of a rounded rect.
        let cornerRadius = bounds.size.height * 0.2
        
        // Assign a value to the path.
        path = NSBezierPath(roundedRect: noteRect!, xRadius: cornerRadius , yRadius: cornerRadius)
        
        if noteModel.getIsDisplayed() == true {
            
            
            // If appropriate, set alpha to ghosting transparency
            if noteModel.getIsGhost() == true {
                noteModel.setMyColor(noteModel.getMyColor().withAlphaComponent(CGFloat(0.4)))
            }
            else {
                noteModel.setMyColor(noteModel.getMyColor().withAlphaComponent(CGFloat(1)))
            }
            
            // Set color and fill.
            
            noteModel.getMyColor().set()
            path?.fill()
            
            // Create an NSParagraphStyle object
            let paraStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
            
            // Set orientation.
            paraStyle.alignment = .right
            
            // define a font.
            let font = NSFont.systemFont(ofSize: noteModel.getNoteFontSize())
            
            // Attributes for drawing.
            let attrs = [
                NSForegroundColorAttributeName: NSColor.black,
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
            attributedNote.drawCenterCustomInRect(bounds, withAttributes: attrs)
        }
    }
}
