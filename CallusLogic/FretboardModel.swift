//
//  FretboardModel.swift
//  CallusLogic
//
//  Copyright © 2016 Gire. All rights reserved.
//  This holds all the setting for creating a Fretboard. 

import Cocoa


class FretboardModel: NSObject, NSCoding {
    
    let NOTES_PER_STRING = 23
    
    let offset = 12
    
    // Offsets for toneNumber for each open string in standard tuning.
    let offsets = [12, 17, 22, 27, 31, 36]
    //##########################################################
    // MARK: - Variables
    //##########################################################
    
    // The array of noteModels that make up the fretboard.
    fileprivate var fretboardArray: [NoteModel]? = []
    
    // The fretboards Title
    fileprivate var fretboardTitle: String? = "Untitled"
    
   
    // The userColor for note selection.
    fileprivate var userColor: NSColor? = NSColor.yellow
    
    fileprivate var isLocked = 0
    fileprivate var zoomLevel = 100.0
    fileprivate var showAdditionalNotes = 0
    
    fileprivate var displayMode = 0
    
    fileprivate var allowsGhostAll = false
    fileprivate var allowsSelectAll = false
    fileprivate var allowsClear = false
    
    
    //##########################################################
    // MARK: - Encoding
    //##########################################################
    func encode(with aCoder: NSCoder) {
        
        // Encode fretboardArray.
        if let fretboardArray = fretboardArray {
            for index in 0...137 {
                aCoder.encode(fretboardArray[index], forKey: "noteModel\(index)")
            }
        }
        // Encode fretboardTitle.
        if let fretboardTitle = fretboardTitle {
            aCoder.encode(fretboardTitle, forKey: "fretboardTitle")
        }
        // Encode userColor.
        if let userColor = userColor {
            aCoder.encode(userColor, forKey: "userColor")
        }
        // Encode isLocked.
        aCoder.encode(isLocked, forKey: "isLocked")
        
        //Encode zoomLevel
        aCoder.encode(zoomLevel, forKey: "zoomLevel")
        
        // Encode showAdditionalNotes.
        aCoder.encode(showAdditionalNotes, forKey: "showAdditionalNotes")
        
        
        // Encode displayMode.
        aCoder.encode(displayMode, forKey: "displayMode")
    
        aCoder.encode(allowsGhostAll, forKey: "allowsGhostAll")
        aCoder.encode(allowsSelectAll, forKey: "allowsSelectAll")
        aCoder.encode(allowsClear, forKey: "allowsClear")
    }
    
    
    //##########################################################
    // MARK: - Decoding
    //##########################################################
    required init?(coder aDecoder: NSCoder) {
        
        // Decode fretboardArray
        for index in 0...137 {
            if let noteModel = aDecoder.decodeObject(forKey: "noteModel\(index)"){
                fretboardArray!.append(noteModel as! NoteModel)
            }
        }
        
        // Decode fretboardTitle
        fretboardTitle = aDecoder.decodeObject(forKey: "fretboardTitle") as! String?
        
        userColor = aDecoder.decodeObject(forKey: "userColor") as! NSColor?
        
        // Decode isLocked.
        isLocked = aDecoder.decodeInteger(forKey: "isLocked")
        
        // Decode zoomLevel
        // Check for the coded value, if available, decode... else it's set to 100.
        if aDecoder.containsValue(forKey: "zoomLevel") {
            zoomLevel = aDecoder.decodeDouble(forKey: "zoomLevel")
        }

        showAdditionalNotes = aDecoder.decodeInteger(forKey: "showAdditionalNotes")
        displayMode = aDecoder.decodeInteger(forKey: "displayMode")
        
        allowsGhostAll = aDecoder.decodeBool(forKey: "allowsGhostAll")
        allowsSelectAll = aDecoder.decodeBool(forKey: "allowsSelectAll")
        allowsClear = aDecoder.decodeBool(forKey: "allowsClear")
        
        super.init()
        // Set fret numbers when decoding, don't bother checking anything.
        setFretNumbers()
        
    }
    
    // Reqiured init.
    override init(){
        super.init()
        
        // If no encoded fretboardModel was loaded, build a fretboard model.
        if fretboardArray!.count == 0 {
            // Build 138 item array of NoteModels.
            var temp : [NoteModel] = []
            for _ in 0...137 {
                temp.append(NoteModel())
            }
            fretboardArray = temp
        }
        setFretNumbers()
    }
  
    fileprivate func setFretNumbers() {
    
        var fret = 0
        for note in fretboardArray! {
            note.setFretNumber(String(fret))
            fret += 1
            if fret == 23 {
                fret = 0
            }
        }
    }
    /* ArrayOfArrays order:
     0 = zeroTo11Array
     1 = zeroTo46Array
     2 = notesArray
     3 = intervalsArray
    */
    // Function takes an array of tone arrays and updates the appropriate noteModels.
    func updateNoteModels(_ anArrayOfToneArrays: [[String]], isInScale: Bool) {
        
        // Internal function to prevent duplicate code.
        func updateSingleModel(noteModel: NoteModel, index: Int) {
            noteModel.setNumber0to11(anArrayOfToneArrays[0][index])
            noteModel.setNumber0to46(anArrayOfToneArrays[1][index])
            noteModel.setNote(anArrayOfToneArrays[2][index])
            noteModel.setInterval(anArrayOfToneArrays[3][index])
            noteModel.setIsInScale(isInScale)
            noteModel.setIsDisplayed(isInScale)
            if isInScale == false {
                noteModel.setMyColor(NSColor.red)
            }
            else {
                noteModel.setMyColor(userColor!)
            }
        }
        
        // For each string
        for stringIndex in 0...5 {
            // For each fret along the string. Total frets = 23 counting 0 as 1.
            for fretIndex in 0...NOTES_PER_STRING - 1 {
                //get the array values and plug update the fretboard model.
                
                let toneIndex = fretIndex + offsets[stringIndex]
                if let noteModel = fretboardArray?[fretIndex  + stringIndex * NOTES_PER_STRING]{
                    
                    
                    if noteModel.getIsKept() == false && isInScale {
                        updateSingleModel(noteModel: noteModel, index: toneIndex)
                    }
                    else if isInScale == false && noteModel.getNote() == "" {
                        updateSingleModel(noteModel: noteModel, index: toneIndex)
                    }
                        
                }
            }
        }
    }
    
    func showNotesOnFretboard( _ _isInScale: Bool, _isDisplayed: Bool, _isGhosted: Bool) {
        for index in 0...137 {
            let noteModel = fretboardArray![index]
            
            // if is note kept
            if noteModel.getIsKept() != true {
                // if the noteModels isInScale bool value equals the passed value.
                // Allows me to update notes in the scale(if bool is true), or additional notes (if bool is false).
                if noteModel.getIsInScale() == _isInScale {
                    // pass isDisplayed and isGhosted,
                    noteModel.setIsDisplayed(_isDisplayed)
                    noteModel.setIsGhost(_isGhosted)
                    // futhermore, if isInScale == true, set the user color.
                    if _isInScale == true {
                        noteModel.setMyColor(userColor!)
                    }
                }
            }
        }
    }
    
    func keepOrUnkeepSelectedNotes(_ doKeep: Bool) {
        for index in 0...137 {
            let noteModel = fretboardArray![index]
            // If ghosted, don't keep
            if noteModel.getIsGhost() == true {
                noteModel.setIsKept(false)
            }
                // If unghosted (selected), keep or unkeep depending on the value of 'doKeep
            else {
                noteModel.setIsKept(doKeep)
                // If we've unSelected the note via unselectAll
                // update the ghost value and display with current value.
                if doKeep == false {
                    noteModel.setIsGhost(true)
                }
            }
        }
    }
    
    
    //##########################################################
    // MARK: - Getters and Setters.
    //##########################################################
    func getFretboardArray()-> [NoteModel] {
        return fretboardArray!
    }
    
    func getFretboardArrayCopy()-> [NoteModel] {
        var array:[NoteModel] = []
        
        for index in 0...(fretboardArray!.count - 1) {
            
           
            let note = NoteModel()
            note.setNoteModel(fretboardArray![index])
            array.append(note)
        }
        
        return array
    }
    
    func setFretboardArray(_ newArray: [NoteModel]) {
        fretboardArray = newArray
    }
    
    func getFretboardTitle()-> String {
        return fretboardTitle!
    }
    
    func setFretboardTitle(_ newTitle: String) {
        fretboardTitle = newTitle
    }
    
    func getUserColor()-> NSColor {
        return userColor!
    }
    
    func setUserColor(_ newColor: NSColor) {
        userColor = newColor
    }
    
    func setIsLocked(_ state: Int) {
        isLocked = state
    }
    func getIsLocked()-> Int {
        return isLocked
    }
    
    func setZoomLevel(_ level: Double) {
        zoomLevel = level
    }
    
    func getZoomLevel()-> Double {
        return zoomLevel
    }
    
    func setShowAdditionalNotes(_ int: Int) {
        showAdditionalNotes = int
    }
    func getShowAdditionalNotes()->Int {
        return showAdditionalNotes
    }
    
    func setDisplayMode(_ index: Int) {
        displayMode = index
    }
    func getDisplayMode()->Int {
        return displayMode
    }

    func setAllowsGhostAll(_ bool: Bool) {
        allowsGhostAll = bool
    }
    
    func getAllowsGhostAll()-> Bool {
        return allowsGhostAll
    }
    
    func setAllowsSelectAll(_ bool: Bool) {
        allowsSelectAll = bool
    }
    
    func getAllowsSelectAll()-> Bool {
        return allowsSelectAll
    }
    
    func setAllowsClear(_ bool: Bool) {
        allowsClear = bool
    }
    
    func getAllowsClear()-> Bool {
        return allowsClear
    }
}

