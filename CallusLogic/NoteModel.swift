//
//  noteModel.swift
//  StringNotesCalculator
//
//  Copyright © 2016 Gire. All rights reserved.
//  Model for the NoteView. 

import Cocoa

class NoteModel {
    
    
    // The position of the note on the entire fretboard. 0-137
    private var fretboardPosition: Int?
    private var note = ""
    private var number0to11 = ""
    private var number0to46 = ""
    private var interval = ""
        
    private var isGhost = false
    private var isInScale = false
    
    private var isDisplayed = false
    private var isPassingNote = false {
        didSet {
            if isPassingNote == true {
                makePassingNote()
            }
        }
    }
    
    // This variable indicates whether editing the view is allowed.
    //private var canCustomize = false
    
    // FontSize
    private var noteFontSize: CGFloat = 16
    
    // The user Selected Color
    private var userColor = NSColor.yellowColor()
    
    // A state variable to be set while the mouse is down.
    private var myColor: NSColor = NSColor.yellowColor()
    
    // The display mode is read from the fretboard Calculator, determines which note display mode to use.
    private var displayMode = ""
    
    // Indicates the note should be kept.
    private var isKept = false
    
    
    
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
       // needsDisplay = true
    }
    
//    func getCanCustomize() -> Bool {
//        return canCustomize
//    }
//    
//    func setCanCustomize(bool: Bool){
//        canCustomize = bool
//    }
    
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
    
    func getUserColor() -> NSColor {
        return userColor
    }
    
    func setUserColor(newColor: NSColor){
        userColor = newColor
    }
    
    func getIsKept() -> Bool {
        return isKept
    }
    
    func setIsKept(bool: Bool){
        isKept = bool
    }
    
    
    func doesMyColorEqualUserColor()-> Bool {
        return myColor == userColor
    }
    
    
    
    private func makePassingNote() {
        note = addParentheses(note)
        number0to11 = addParentheses(number0to11)
        number0to46 = addParentheses(number0to46)
        interval = addParentheses(interval)
    }
    
    private func addParentheses(theNote: String)-> String {
        var temp = "("
        temp = temp.stringByAppendingString(theNote)
        temp = temp.stringByAppendingString(")")
        return temp
    }
    
}
