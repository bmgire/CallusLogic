//
//  noteModel.swift
//  StringNotesCalculator
//
//  Copyright © 2016 Gire. All rights reserved.
//  Model for the NoteView. 

import Foundation

class NoteModel {
    
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
