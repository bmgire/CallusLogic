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
        zoomLevel = aDecoder.decodeDouble(forKey: "zoomLevel")

        showAdditionalNotes = aDecoder.decodeInteger(forKey: "showAdditionalNotes")
        displayMode = aDecoder.decodeInteger(forKey: "displayMode")
        
        allowsGhostAll = aDecoder.decodeBool(forKey: "allowsGhostAll")
        allowsSelectAll = aDecoder.decodeBool(forKey: "allowsSelectAll")
        allowsClear = aDecoder.decodeBool(forKey: "allowsClear")
        
        super.init()
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

