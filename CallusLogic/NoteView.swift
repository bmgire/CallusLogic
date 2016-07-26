//  Copyright © 2016 Gire. All rights reserved.
//  NoteView and Controller for the NoteView objects in the FretboardView.


import Cocoa

class NoteView: NSView {
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    
    var viewNumberDict: [String: Int] = [:]

    private var noteModel = NoteModel()
    
    // Indicates whether the button has been pressed successfully.
    private var pressed: Bool = false
    
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
        needsDisplay = true
    }
    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        
//        
//    
//    }
//    
//    init() {
//        super.init(frame: NSMakeRect(0, 0, 0, 0))
//        // Setup path.
//        noteRect = bounds.insetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05)
//        // Defines the radius of the corners of a rounded rect.
//        let cornerRadius = bounds.size.height * 0.2
//        // Assign a value to the path.
//        path = NSBezierPath(roundedRect: noteRect!, xRadius: cornerRadius , yRadius: cornerRadius)
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    

    


    
    
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
        
        if pressed {
            // Posts a notification and specifies which object sent the notification.
            NSNotificationCenter.defaultCenter().postNotificationName("noteViewMouseUpEvent", object: self, userInfo: viewNumberDict)
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
    private func drawNote() {
        // Assigns a value to the noteRect.
        noteRect = bounds.insetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05)
        
        // Defines the radius of the corners of a rounded rect.
        let cornerRadius = bounds.size.height * 0.2
        
        // Assign a value to the path.
        path = NSBezierPath(roundedRect: noteRect!, xRadius: cornerRadius , yRadius: cornerRadius)
        
        if noteModel.getIsDisplayed() == true {
            
            
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
            
            attributedNote.drawCenterCustomInRect(bounds, withAttributes: attrs)
        }
    }
}
