//  FretboardView.swift
//
//  This class defines the fretboard.
//  The FretboardView holds 6 StringsViews.
//  Each string holds 22 NoteViews.
//  The Fretboard contains a FretboardModel which gets updated by the UI.
//  The fretboard model then updates the Note views with info from the FretboardModel. 
//  The noteviews are never destroyed.


import Cocoa

class FretboardView: NSView {
    
    // Outlets to user buttons.


    // MARK: Variables
    
    var offsets = [0, 5, 10, 15, 19, 24]   // Array to hold guitarString offsets
    
    // Used for building Note Rects.
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
    
    // Used for building Note Rects.
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
    
    // Radians for guitar string rotation, ordered from highest pitched string to lowest.
    let radians: [CGFloat] =
         [ -0.02094,
            -0.01604,
          -0.01,
          0.00046,
          0.00796,
          0.01396]
    


    
    let stringHeightMultipliers: [CGFloat] =
        [0.16,
         0.269,
         0.38,
         0.49,
         0.6,
         0.71]
    
    
    var rectArray: [CGRect] = []          // holds the rects
    var noteViewArray: [NoteView] = []      // Holds the notes
    var noteModelArray: [NoteModel] = []       // Array of noteModels.
    
    var displayMode = "note"
    let NOTES_PER_STRING = 23
    
    // The image shown in this custom view.
    @IBInspectable var image :NSImage?
 
    override func awakeFromNib() {

        for index in 0...5{
            buildNoteRects(stringHeightMultipliers[index], radians: radians[index])
        }
        
        buildNoteViews()
        addSubviews()
    }

    
    override func drawRect(dirtyRect: CGRect) {
       
            // Declare the image object that will be drawn.
            if let image = image {
                
                let imageRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
                
                
                // update content for drawing
                updateSubviews()
                image.drawInRect(imageRect)
            }
     
    }
    
    // Intrinsic size must be overriden in order for the fretboard image to appear in the Scroll view.
    // The intrisic size will also be the the exact size of the fretboard so I have to re-create this frame in IB for this view. 
    // Otherwise it will look wierd.
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 1780, height: 262)
    }

    // Build Note Rects.
    func buildNoteRects(yFactor: CGFloat, radians: CGFloat) {
        var tempRects:[CGRect] = rectArray
        var length = frame.maxX
        if radians < 0 {
            length *= 0.998
        }
        
        let height = frame.maxY
        var noteX = CGFloat(0)
        
        
        
        for index in 0...22 {
            noteX = length * frets[index]
            tempRects.append(CGRect(x: noteX, y: height * yFactor + sin(radians) * noteX , width: noteWidths[index], height: 25))
        }
        
        // Everytime an array of rects is built, add array to array of arrays.
        rectArray = tempRects

    }
    
    // Builds the noteViewsArray.
    func buildNoteViews() {

        
        // String index represents each guitar string. 0 is highest pitch, 5 is lowest.
        for stringIndex in 0...5 {
            // rectIndex is the index of each notes rect on each guitar string.
            for noteIndex in 0...(NOTES_PER_STRING - 1) {
                let note = NoteView()
                // Update the appropriate frame.
                note.frame = rectArray[noteIndex + stringIndex * NOTES_PER_STRING]
                // Adjust fonts for frets with small widths.
                
                if noteIndex != 0 {
                    
                note.rotateByAngle(radians[stringIndex] * CGFloat(180/M_PI)) //degreeArray[stringIndex])
                }
                
                if noteIndex > 19 {
                    if noteIndex == 20 {
                        note.noteFont = 14
                    }
                    else if noteIndex == 21 {
                        note.noteFont = 13
                    }
                    else if noteIndex == 22 {
                        note.noteFont = 12
                    }
                    
                }
                
                
                noteViewArray.append(note)
            }
        }
    }
    

    func addSubviews() {
        for index in 0...(rectArray.count - 1) {
            addSubview(noteViewArray[index])
        }
    }
    
    // Updates the contents of each noteView.
    func updateSubviews() {
            for stringIndex in 0...5 {
                for noteIndex in 0...(NOTES_PER_STRING - 1){
                    // Update note
                    (subviews[noteIndex + (stringIndex * NOTES_PER_STRING)] as! NoteView).note =
                        noteModelArray[noteIndex + offsets[stringIndex]].note
                    // Update intervals
                    (subviews[noteIndex + (stringIndex * NOTES_PER_STRING)] as! NoteView).interval =
                        noteModelArray[noteIndex + offsets[stringIndex]].interval
                    // Update number0to11
                    (subviews[noteIndex + (stringIndex * NOTES_PER_STRING)] as! NoteView).number0to11 =
                        noteModelArray[noteIndex + offsets[stringIndex]].number0to11
                    // Update number0to46
                    (subviews[noteIndex + (stringIndex * NOTES_PER_STRING)] as! NoteView).number0to46 =
                        noteModelArray[noteIndex + offsets[stringIndex]].number0to46
                    // Update fretDisplay
                    (subviews[noteIndex + (stringIndex * NOTES_PER_STRING)] as! NoteView).fretDisplay =
                        displayMode
                }
            }
        
    }
    

    
    //update string notes
    func updateNoteModelArray(newNotesArray: [NoteModel]) {
        noteModelArray = newNotesArray
    }
    
  
    
    
}

