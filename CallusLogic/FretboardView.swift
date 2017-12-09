//  Copyright © 2016 Gire. All rights reserved.
//  This class defines the FretboardView and it's controls.
//  The FretboardView holds 6 StringsViews.
//  Each string holds 23 NoteViews.
//  The FretboardView then updates the Note views with info from the FretboardCalculator. 
//  The noteviews are never destroyed.


import Cocoa

class FretboardView: NSView {
    
    
    //##########################################################
    // MARK: - Constants
    //##########################################################
    
    // Constant of the number of notes per string on a 22 fret guitar.
    let NOTES_PER_STRING = 23
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    
    // holds the rects used to create all NoteViews.
    fileprivate var rectArray: [CGRect] = []
    
    // Holds the NoteViews
    fileprivate var noteViewArray: [NoteView] = []

    // The image shown in this custom view.
    @objc var image :NSImage?
    
    //##########################################################
    // MARK: Arrays
    //##########################################################
    
    // Array to hold guitarString offsets
    fileprivate var offsets = [0, 5, 10, 15, 19, 24]
    
    // Arrays of CGFloat magic number multipliers to correctly represent fret locations.
    let frets: [CGFloat] =
           [0.008,  // 0
            0.079,
            0.144,
            0.206, // 3
            0.265,
            0.322, // 5
            0.375,
            0.426, // 7
            0.475,
            0.521,
            0.564, // 10
            0.606,
            0.645, // 12
            0.683,
            0.721,
            0.755, // 15
            0.789,
            0.820, // 17
            0.850,
            0.878,
            0.905, // 20
            0.930,
            0.954] // 22
    
    
    // Arrays of CGFloat magic numbers to correctly represent fret widths.
    let noteWidths: [CGFloat] =
        [ 54,
          59,
          59,
          59,
          59,
          59,
          59,
          59,
          58,
          58,
          58,
          58,
          58,
          58,
          51,
          50,
          45,
          43,
          40,
          37,
          34,
          33,
          32]
    
    // Radians for guitar string rotation, ordered from lowest pitched string to highest.
    let radians: [CGFloat] =
         [-0.02094,
          -0.01604,
          -0.01,
           0.00046,
           0.00796,
           0.01396]
    
    // Multipliers to correctly place each set of notes onto the appropriate 
    //guitar String, relative to the pictures bounds.
    let stringHeightMultipliers: [CGFloat] =
        [0.16,
         0.269,
         0.38,
         0.49,
         0.6,
         0.71]

    //##########################################################
    // MARK: - Overridden functions
    //##########################################################
    
    // Tasks required from the Nib.
    override func awakeFromNib() {
        
        // Build rects for each guitar string of notes.
        for index in 0...5{
            buildNoteRects(stringHeightMultipliers[index], radians: radians[index])
        }
        buildNoteViews()
        addSubviews()
    }

    // Draws in the NSView.
    override func draw(_ dirtyRect: CGRect) {
       
            // Declare the image object that will be drawn.
            if let image = image {
                
                let imageRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
                // update content for drawing
                // updateSubviews()
                // Draw the image of the fretboard.
                image.draw(in: imageRect)
            }
     
    }
    
    // Intrinsic size must be overriden in order for the fretboard image to appear in the Scroll view.
    // The intrisic size will also be the the exact size of the fretboard so I have to re-create this frame in IB for this view.
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 1790, height: 262)
    }
    
    //##########################################################
    // MARK: - Custom functions
    //##########################################################
    
    // Build Note Rects.
    fileprivate func buildNoteRects(_ yMultiplier: CGFloat, radians: CGFloat) {
        
        // Create a temp array and copy any rects in rectArray to it.
        var tempRects:[CGRect] = rectArray
        
        var length = bounds.maxX
        
        // Adjusts the lengths of the bottom 3 strings on a right handed guitar
        // for aesthetic purposes.
        if radians < 0 {
            length *= 0.998
        }
        
        let height = bounds.maxY
        
        // the X value of the first NoteViews Rect.
        var noteX = CGFloat(0)
        
        // For all notes.
        for index in 0...22 {
            
            // Calculate the X position.
            noteX = length * frets[index]
            // Build the rect and append
            tempRects.append(CGRect(x: noteX, y: height * yMultiplier + sin(radians) * noteX , width: noteWidths[index], height: 25))
        }
        
        // update RectArray.
        rectArray = tempRects
    }
    
    // Builds the noteViewsArray.
    fileprivate func buildNoteViews() {
        
        // String index represents each guitar string. 0 is highest pitch, 5 is lowest.
        for stringIndex in 0...5 {
            // rectIndex is the index of each notes rect on each guitar string.
            for noteIndex in 0...(NOTES_PER_STRING - 1) {
                let note = NoteView()
                
                let index = noteIndex + stringIndex * NOTES_PER_STRING
                
                // Update the appropriate frame.
                note.frame = rectArray[index]
                // Adjust fonts for frets with small widths.
                
                // The views number in the fretboard, for NoteView identification for Event notifications. 
                note.viewNumberDict = ["number" : index]
                
                // If the NoteView isn't at the nut, rotate it.
                if noteIndex != 0 {
                    note.rotate(byDegrees: radians[stringIndex] * CGFloat(180/Double.pi))
                }
                noteViewArray.append(note)
            }
        }
    }
    
    // Add all NoteViews as subviews. 
    fileprivate func addSubviews() {
        for index in 0...(noteViewArray.count - 1) {
            addSubview(noteViewArray[index])
        }
    }
    
    // Updates the contents of each noteView.
    func updateSubviews(_ fretboardArray: [NoteModel], displayMode: String) {
        for index in 0...137  {
            let view = subviews[index] as! NoteView
            let noteModel = fretboardArray[index]
            
            var displayText = ""
            
            switch displayMode {
            case "Fret Numbers":
                displayText = noteModel.getFretNumber()
            case "Intervals":
                displayText = noteModel.getInterval()
            case "Numbers 0-11":
                displayText = noteModel.getNumber0to11()
            case "Numbers 0-46":
                displayText = noteModel.getNumber0to46()
            default:
                displayText = noteModel.getNote()
            }
            
            // Update noteView
            view.updateNoteView(noteModel, display: displayText)
          
        }
        needsDisplay = true
    }
}


