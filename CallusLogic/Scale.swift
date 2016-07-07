//
//  Scale.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 5/1/16.
//  Copyright © 2016 Gire. All rights reserved.
//

// Attempting not to import cocoa.
import Cocoa

// I'm attempting to try without subclassing from NSObject
class Scale: NSObject {
    
 
    var scaleName: String = ""
    var scaleFormula: [String] = []
    var passingIndex: Int?
    var hasPassingNote: Bool = false
    
    // Initialise the scale with values.
    init(name: String, formula: [String], passingNoteIndex: Int) {
       
        scaleName = name
        scaleFormula = formula
        passingIndex = passingNoteIndex
        
        if passingNoteIndex != -1 {
            hasPassingNote = true
        }
        
        
        
        // In Swift you must initialize all your variables before attempting to initialize the Super Class. 
         super.init()
    }
    
    // Get the passingIndex
    func getPassingIndex()->Int? {
        return passingIndex
    }
    
    func getScaleName()->String {
        return scaleName
    }
    
    func getFormula()->[String] {
        return scaleFormula
    }
    
    
    
    
    
}