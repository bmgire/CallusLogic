//
//  noteModel.swift
//  StringNotesCalculator
//
//  Copyright © 2016 Gire. All rights reserved.
//  Model for the NoteView. 

import Cocoa
class NoteModel: NSObject, NSCoding {
    
    // The position of the note on the entire fretboard. 0-137
    fileprivate var note = ""
    fileprivate var number0to11 = ""
    fileprivate var number0to46 = ""
    fileprivate var interval = ""
    fileprivate var fretNumber = ""
    
    /// var attributedNote = NSMutableAttributedString()
    fileprivate var isGhost = true
    fileprivate var isInScale = false
    fileprivate var isDisplayed = false
    fileprivate var isPassingNote = false
    
    // Indicates the note should be kept.
    fileprivate var isKept = false
    
    // FontSize
    fileprivate var noteFontSize: CGFloat = 16
    
    // A state variable to be set while the mouse is down.
    fileprivate var myColor: NSColor = NSColor.red
    
    // The display mode is read from the fretboard Calculator, determines which note display mode to use.
    fileprivate var displayMode = "Notes"
     
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(note, forKey: "note")
        aCoder.encode(number0to11, forKey: "number0to11")
        aCoder.encode(number0to46, forKey: "number0to46")
        aCoder.encode(interval, forKey: "interval")
        
        aCoder.encode(isGhost, forKey: "isGhost")
        aCoder.encode(isInScale, forKey: "isInScale")
        aCoder.encode(isDisplayed, forKey: "isDisplayed")
        aCoder.encode(isPassingNote, forKey: "isPassingNote")
        aCoder.encode(isKept, forKey: "isKept")
        
        aCoder.encode(noteFontSize, forKey: "noteFontSize")
        aCoder.encode(myColor, forKey: "myColor")
        aCoder.encode(displayMode, forKey: "displayMode")
    }
    
    required init?(coder aDecoder: NSCoder) {
        note = aDecoder.decodeObject(forKey: "note") as! String
        number0to11 = aDecoder.decodeObject(forKey: "number0to11") as! String
        number0to46 = aDecoder.decodeObject(forKey: "number0to46") as! String
        interval = aDecoder.decodeObject(forKey: "interval") as! String
        
        isGhost = aDecoder.decodeBool(forKey: "isGhost")
        isInScale = aDecoder.decodeBool(forKey: "isInScale")
        isDisplayed = aDecoder.decodeBool(forKey: "isDisplayed")
        isPassingNote = aDecoder.decodeBool(forKey: "isPassingNote")
        isKept = aDecoder.decodeBool(forKey: "isKept")
        
        noteFontSize = aDecoder.decodeObject(forKey: "noteFontSize") as! CGFloat
        myColor = aDecoder.decodeObject(forKey: "myColor") as! NSColor
        displayMode = aDecoder.decodeObject(forKey: "displayMode") as! String
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    //####################################
    // Getters and setters.
    //####################################
    func getNote()-> String {
        return note
    }
    
    func setNote(_ newNote: String) {
        note = newNote
    }
    
    func getNumber0to11()-> String {
        return number0to11
    }
    
    func setNumber0to11(_ newNumber: String) {
        number0to11 = newNumber
    }
    
    func getNumber0to46()-> String {
        return number0to46
    }
    
    func setNumber0to46(_ newNumber: String) {
        number0to46 = newNumber
    }
    
    func getInterval()-> String {
        return interval
    }
    
    func setInterval(_ newInterval: String) {
        interval = newInterval
    }
    
    func getFretNumber()-> String {
        return fretNumber
    }
    
    func setFretNumber(_ newFretNumber: String) {
        fretNumber = newFretNumber
    }
    
    
    func getIsGhost()-> Bool {
        return isGhost
    }
    
    func setIsGhost(_ bool: Bool) {
        isGhost = bool
    }
    
    func getIsInScale()-> Bool {
        return isInScale
    }
    
    func setIsInScale(_ bool: Bool) {
        isInScale = bool
    }
    
    func getIsDisplayed()-> Bool {
        return isDisplayed
    }
    
    func setIsDisplayed(_ bool: Bool) {
        isDisplayed = bool
    }
    
    func getIsPassingNote()-> Bool {
        return isPassingNote
    }
    
    func setIsPassingNote(_ bool: Bool) {
        isPassingNote = bool
    }
    
    func getDisplayMode() -> String {
        return displayMode
    }
    
    func setDisplayMode(_ newMode: String){
        displayMode = newMode
    }
    

    func getNoteFontSize() -> CGFloat {
        return noteFontSize
    }
    
    func setNoteFontSize(_ newFontSize: CGFloat){
        noteFontSize = newFontSize
    }
    
    func getMyColor() -> NSColor {
        return myColor
    }
    
    func setMyColor(_ newColor: NSColor){
        myColor = newColor
    }
    
    func getIsKept() -> Bool {
        return isKept
    }
    
    func setIsKept(_ bool: Bool){
        isKept = bool
    }
    
    
    func makePassingNote(_ bool: Bool) {
        if bool {
            note = addParentheses(note)
            number0to11 = addParentheses(number0to11)
            number0to46 = addParentheses(number0to46)
            interval = addParentheses(interval)
            if fretNumber != "" {
            fretNumber = addParentheses(fretNumber)
            }
        }
        else {
            note = removeParentheses(note)
            number0to11 = removeParentheses(number0to11)
            number0to46 = removeParentheses(number0to46)
            interval = removeParentheses(interval)
            interval = removeParentheses(fretNumber)
            if fretNumber != "" {
                fretNumber = removeParentheses(fretNumber)
            }
        }
    }
    
    fileprivate func addParentheses(_ theNote: String)-> String {
        var temp = "("
        temp = temp + theNote
        temp = temp + ")"
        //print(theNote)
        print(temp)
        return temp
    }
    
    // note being used yet.
    fileprivate func removeParentheses(_ theString: String)->String {
        var temp = theString
        
        let begin = temp.startIndex
        let end = temp.endIndex
        
        temp.remove(at: end)
        temp.remove(at: begin)
        return temp
    }
    
    func setNoteModel(_ newModel: NoteModel) {
        note = newModel.getNote()
        number0to11 = newModel.getNumber0to11()
        number0to46 = newModel.getNumber0to46()
        interval = newModel.getInterval()
        if newModel.fretNumber != ""{
          fretNumber = newModel.getFretNumber()
        }
        isGhost = newModel.getIsGhost()
        isInScale = newModel.getIsInScale()
        isDisplayed = newModel.getIsDisplayed()
        isPassingNote = newModel.getIsPassingNote()
        noteFontSize = newModel.getNoteFontSize()
        myColor = newModel.getMyColor()
        displayMode = newModel.getDisplayMode()
        isKept = newModel.isKept
    }
    

}
