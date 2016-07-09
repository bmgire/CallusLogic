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
    var number = ""
    
    func getNote()-> (String) {
        return note
    }
    
    func setNote(newNote: String) {
        note = newNote
    }
}
