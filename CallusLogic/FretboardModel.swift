//
//  FretboardModel.swift
//  CallusLogic
//
//  Copyright © 2016 Gire. All rights reserved.
//  This holds all the setting for creating a Fretboard. 

import Cocoa


class FretboardModel: NSObject, NSCoding {
    
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    
    // The array of noteModels that make up the fretboard.
    private var fretboardArray: [NoteModel]? = []
    
    // The fretboards Title
    private var fretboardTitle: String? = "Untitled"
    
   
    
    // The userColor for note selection.
    private var userColor: NSColor? = NSColor.yellowColor()
    
    // Whether the fretboard is locked for editing.
    private var isLocked = 0
    
//    private var showCalcedNotes = 1
//    
//    private var selectCalcedNotes = 0
    
    private var showAdditionalNotes = 0
    
//    private var selectAdditionalNotes = 0
    
    private var displayMode = 0
    
    
    
    //##########################################################
    // MARK: - Encoding
    //##########################################################
    // MARK:- Encoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        // Encode fretboardArray.
        if let fretboardArray = fretboardArray {
            for index in 0...137 {
                aCoder.encodeObject(fretboardArray[index], forKey: "noteModel\(index)")
            }
        }
        // Encode fretboardTitle.
        if let fretboardTitle = fretboardTitle {
            aCoder.encodeObject(fretboardTitle, forKey: "fretboardTitle")
        }
        // Encode userColor.
        if let userColor = userColor {
            aCoder.encodeObject(userColor, forKey: "userColor")
        }
        // Encode isLocked.
        aCoder.encodeInteger(isLocked, forKey: "isLocked")
        
//        // Encode showCalcedNotes.
//        aCoder.encodeInteger(showCalcedNotes, forKey: "showCalcedNotes")
//        
//        // Encode selectCalcedNotes.
//        aCoder.encodeInteger(selectCalcedNotes, forKey: "selectCalcedNotes")
        
        // Encode showAdditionalNotes.
        aCoder.encodeInteger(showAdditionalNotes, forKey: "showAdditionalNotes")
        
//        // Encode selectAdditionalNotes.
//        aCoder.encodeInteger(selectAdditionalNotes, forKey: "selectAdditionalNotes")
        
        // Encode displayMode.
        aCoder.encodeInteger(displayMode, forKey: "displayMode")
    }
    
    //##########################################################
    // MARK: - Decoding
    //##########################################################
    required init?(coder aDecoder: NSCoder) {
        
        // Decode fretboardArray
        for index in 0...137 {
            if let noteModel = aDecoder.decodeObjectForKey("noteModel\(index)"){
                fretboardArray!.append(noteModel as! NoteModel)
            }
        }
        
        // Decode fretboardTitle
        fretboardTitle = aDecoder.decodeObjectForKey("fretboardTitle") as! String?
        
        userColor = aDecoder.decodeObjectForKey("userColor") as! NSColor?
        
        // Decode isLocked.
        isLocked = aDecoder.decodeIntegerForKey("isLocked")
        
//        showCalcedNotes = aDecoder.decodeIntegerForKey("showCalcedNotes")
//        selectCalcedNotes = aDecoder.decodeIntegerForKey("selectCalcedNotes")
        showAdditionalNotes = aDecoder.decodeIntegerForKey("showAdditionalNotes")
//        selectAdditionalNotes = aDecoder.decodeIntegerForKey("selectAdditionalNotes")
        displayMode = aDecoder.decodeIntegerForKey("displayMode")
        
        super.init()
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
    
    func setFretboardArray(newArray: [NoteModel]) {
        fretboardArray = newArray
    }
    
    func getFretboardTitle()-> String {
        return fretboardTitle!
    }
    
    func setFretboardTitle(newTitle: String) {
        fretboardTitle = newTitle
    }
    
    func getUserColor()-> NSColor {
        return userColor!
    }
    
    func setUserColor(newColor: NSColor) {
        userColor = newColor
    }
    
    func setIsLocked(state: Int) {
        isLocked = state
    }
    func getIsLocked()-> Int {
        return isLocked
    }
    
        
//    func setShowCalcedNotes(int: Int) {
//        showCalcedNotes = int
//    }
//    
//    func getShowCalcedNotes()->Int {
//        return showCalcedNotes
//    }
//
//    func setSelectCalcedNotes(int: Int) {
//        selectCalcedNotes = int
//    }
//    func getSelectCalcedNotes()->Int {
//        return selectCalcedNotes
//    }
//    
    func setShowAdditionalNotes(int: Int) {
        showAdditionalNotes = int
    }
    func getShowAdditionalNotes()->Int {
        return showAdditionalNotes
    }
    
//    func setSelectAdditionalNotes(int: Int) {
//        selectAdditionalNotes = int
//    }
//    func getSelectAdditionalNotes()->Int {
//        return selectAdditionalNotes
//    }
    
    func setDisplayMode(index: Int) {
        displayMode = index
    }
    func getDisplayMode()->Int {
        return displayMode
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
    }
}

