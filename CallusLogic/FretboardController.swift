//
//  FretboardController.swift
//  CallusLogic
//
//  Created by Ben Gire on 7/19/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class FretboardController: NSViewController {
    
    let NOTES_PER_STRING = 23
    
    let fretboardModel = FretboardModel()
    
    //private var zeroTo46ToneArray: [NoteModel] = []
    
    private var offsets = [0, 5, 10, 15, 19, 24]
    
    private var userColor = NSColor.yellowColor()
    
    // represents the display mode = (Notes, Intervals, Numbers...)
    private var displayMode = ""
    
    private var canCustomize = false
    
    // @IBOutlet weak var fretboardView: FretboardView?
    
    let fretboardView = FretboardView()
    
    func getDisplayMode() -> String {
        return displayMode
    }
    
    func setDisplayMode(newMode: String) {
        displayMode = newMode
    }
    
    func setCanCustomize(bool: Bool) {
        canCustomize = bool
    }
    
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(FretboardController.reactToMouseUpEvent(_:)),
                                                         name: "noteViewMouseUpEvent",
                                                         object: nil)
    }
    
    func reactToMouseUpEvent(notification: NSNotification) {
        if canCustomize {
            // store the view number.
            let index = (notification.userInfo!["number"] as! Int)
            let noteModel = fretboardModel.array[index]
            // if myColor hasn't been updated to the new userColor, redraw.
            if noteModel.getMyColor() != userColor {
                
                // Set the color correctly.
                noteModel.setMyColor(userColor)
                
                // and if it isn't ghosted, just changed the color, don't ghost.
                if noteModel.getIsGhost() == true {
                    
                    noteModel.setIsGhost(!noteModel.getIsGhost())
                }
            }
                // Else, the colors are the same, turn unselected notes into selected notes, and vice versa.
            else {
                noteModel.setIsGhost(!noteModel.getIsGhost())
            }
            
            // redraw.
             (notification.object as! NoteView).needsDisplay = true
        }
    }
    
    // Sets the color for Calculated Notes.
    func setUserColor(newColor: NSColor){
        userColor = newColor
    }
    
//    func updateZeroTo46ToneArray(newArray: [NoteModel]) {
//        zeroTo46ToneArray = newArray
//    }
    
    
    func markSelectedNotesAsKept(doKeep: Bool) {
        for index in 0...137 {
                let model = fretboardModel.array[index]
                
                // If the view is displayed, determine whether to keep.
                if model.getIsDisplayed() == true {
                    // If ghosted, don't keep
                    if model.getIsGhost() == true {
                        model.setIsKept(false)
                    }
                        // If unghosted, keep or unkeep depending on the value of 'doKeppt
                    else {
                        model.setIsKept(doKeep)
                        // If we've unSelected the note via unselectAll
                        // update the ghost value and display with current value.
                        if doKeep == false {
                            model.setIsGhost(true)
                        }
                    }
                }
            }
        
        //needsDisplay = true
    }
    
    func updateToneArrayIntoFretboardModel(toneArray: [NoteModel]) {
        for stringIndex in 0...5 {
            for noteIndex in 0...(NOTES_PER_STRING - 1){
                let noteModel = (fretboardModel.array[noteIndex + (stringIndex * NOTES_PER_STRING)])
                let zeroTo46Model = toneArray[noteIndex + offsets[stringIndex]]
                
                // For all noteModels not marked as kept, set the noteModel to the zeroTo46 Model.
                if noteModel.getIsKept() == false {
                    noteModel.setNoteModel(zeroTo46Model)
                }
            }
        }
    }
}



