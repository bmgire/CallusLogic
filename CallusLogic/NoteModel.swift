//
//  noteModel.swift
//  StringNotesCalculator
//
//  Copyright © 2016 Gire. All rights reserved.
//  Model for the NoteView. 

import Cocoa

class NoteModel: NSObject, NSCoding {
    
    // The position of the note on the entire fretboard. 0-137
    private var note = ""
    private var number0to11 = ""
    private var number0to46 = ""
    private var interval = ""
    
    /// var attributedNote = NSMutableAttributedString()
    private var isGhost = false 
    private var isInScale = false
    private var isDisplayed = false
    private var isPassingNote = false
    
    // Indicates the note should be kept.
    private var isKept = false
    
    // FontSize
    private var noteFontSize: CGFloat = 16
    
    // A state variable to be set while the mouse is down.
    private var myColor: NSColor = NSColor.yellowColor()
    
    // The display mode is read from the fretboard Calculator, determines which note display mode to use.
    private var displayMode = "Notes"
     
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(note, forKey: "note")
        aCoder.encodeObject(number0to11, forKey: "number0to11")
        aCoder.encodeObject(number0to46, forKey: "number0to46")
        aCoder.encodeObject(interval, forKey: "interval")
        
        aCoder.encodeBool(isGhost, forKey: "isGhost")
        aCoder.encodeBool(isInScale, forKey: "isInScale")
        aCoder.encodeBool(isDisplayed, forKey: "isDisplayed")
        aCoder.encodeBool(isPassingNote, forKey: "isPassingNote")
        aCoder.encodeBool(isKept, forKey: "isKept")
        
        aCoder.encodeObject(noteFontSize, forKey: "noteFontSize")
        aCoder.encodeObject(myColor, forKey: "myColor")
        aCoder.encodeObject(displayMode, forKey: "displayMode")
    }
    
    required init?(coder aDecoder: NSCoder) {
        note = aDecoder.decodeObjectForKey("note") as! String
        number0to11 = aDecoder.decodeObjectForKey("number0to11") as! String
        number0to46 = aDecoder.decodeObjectForKey("number0to46") as! String
        interval = aDecoder.decodeObjectForKey("interval") as! String
        
        isGhost = aDecoder.decodeBoolForKey("isGhost")
        isInScale = aDecoder.decodeBoolForKey("isInScale")
        isDisplayed = aDecoder.decodeBoolForKey("isDisplayed")
        isPassingNote = aDecoder.decodeBoolForKey("isPassingNote")
        isKept = aDecoder.decodeBoolForKey("isKept")
        
        noteFontSize = aDecoder.decodeObjectForKey("noteFontSize") as! CGFloat
        myColor = aDecoder.decodeObjectForKey("myColor") as! NSColor
        displayMode = aDecoder.decodeObjectForKey("displayMode") as! String
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
    
    func setNote(newNote: String) {
        note = newNote
    }
    
    func getNumber0to11()-> String {
        return number0to11
    }
    
    func setNumber0to11(newNumber: String) {
        number0to11 = newNumber
    }
    
    func getNumber0to46()-> String {
        return number0to46
    }
    
    func setNumber0to46(newNumber: String) {
        number0to46 = newNumber
    }
    
    func getInterval()-> String {
        return interval
    }
    
    func setInterval(newInterval: String) {
        interval = newInterval
    }
    
    
    func getIsGhost()-> Bool {
        return isGhost
    }
    
    func setIsGhost(bool: Bool) {
        isGhost = bool
    }
    
    func getIsInScale()-> Bool {
        return isInScale
    }
    
    func setIsInScale(bool: Bool) {
        isInScale = bool
    }
    
    func getIsDisplayed()-> Bool {
        return isDisplayed
    }
    
    func setIsDisplayed(bool: Bool) {
        isDisplayed = bool
    }
    
    func getIsPassingNote()-> Bool {
        return isPassingNote
    }
    
    func setIsPassingNote(bool: Bool) {
        isPassingNote = bool
    }
    
    func getDisplayMode() -> String {
        return displayMode
    }
    
    func setDisplayMode(newMode: String){
        displayMode = newMode
    }
    

    func getNoteFontSize() -> CGFloat {
        return noteFontSize
    }
    
    func setNoteFontSize(newFontSize: CGFloat){
        noteFontSize = newFontSize
    }
    
    func getMyColor() -> NSColor {
        return myColor
    }
    
    func setMyColor(newColor: NSColor){
        myColor = newColor
    }
    
    func getIsKept() -> Bool {
        return isKept
    }
    
    func setIsKept(bool: Bool){
        isKept = bool
    }
    
    
    func makePassingNote(bool: Bool) {
        if bool {
            note = addParentheses(note)
            number0to11 = addParentheses(number0to11)
            number0to46 = addParentheses(number0to46)
            interval = addParentheses(interval)
        }
        else {
            note = removeParentheses(note)
            number0to11 = removeParentheses(number0to11)
            number0to46 = removeParentheses(number0to46)
            interval = removeParentheses(interval)
        }
    }
    
    private func addParentheses(theNote: String)-> String {
        var temp = "("
        temp = temp.stringByAppendingString(theNote)
        temp = temp.stringByAppendingString(")")
        return temp
    }
    
    // note being used yet.
    private func removeParentheses(theString: String)->String {
        var temp = theString
        
        let begin = temp.startIndex
        let end = temp.endIndex
        
        temp.removeAtIndex(end)
        temp.removeAtIndex(begin)
        return temp
    }
    
    func setNoteModel(newModel: NoteModel) {
        note = newModel.getNote()
        number0to11 = newModel.getNumber0to11()
        number0to46 = newModel.getNumber0to46()
        interval = newModel.getInterval()
        isGhost = newModel.getIsGhost()
        isInScale = newModel.getIsInScale()
        isDisplayed = newModel.getIsDisplayed()
        isPassingNote = newModel.getIsPassingNote()
        noteFontSize = newModel.getNoteFontSize()
        myColor = newModel.getMyColor()
        displayMode = newModel.getDisplayMode()
        isKept = newModel.isKept
    }
    
    func setAttributedNote() {
        
    }
}
