//
//  noteModel.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 5/8/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Foundation

class NoteModel {
    
    var note = ""
    var number0to11 = ""
    var number0to46 = ""
    var interval = ""
    
    var isGhost = false
    var isInscale = false
    
    var isLocked = false
    
    var isKept = false
    
    var isDisplayed = false
    var isPassingNote = false {
        didSet {
            if isPassingNote == true {
                makePassingNote()
            }
        }
    }
    
    func makePassingNote() {
        note = addParentheses(note)
        number0to11 = addParentheses(number0to11)
        number0to46 = addParentheses(number0to46)
        interval = addParentheses(interval)
    }
    
    func addParentheses(theNote: String)-> String {
        var temp = "("
        temp = temp.stringByAppendingString(theNote)
        temp = temp.stringByAppendingString(")")
        return temp
    }
    
    func resetProperties() {
        note = ""
        number0to11 = ""
        number0to46 = ""
        interval = ""
        
        isGhost = false
        isInscale = false
        
        isLocked = false
        
        isDisplayed = false
        isPassingNote = false
        isKept = false
    }
}
