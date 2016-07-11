//
//  Scale.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 5/1/16.
//  Copyright © 2016 Gire. All rights reserved.
//

// Attempting not to import cocoa.
import Foundation

// I'm attempting to try without subclassing from NSObject
class Scale {
    
 
    var scaleName: String = ""
    var scaleFormula: [String] = []
    var passingInterval = ""
//    var hasPassingNote: Bool = false
    
    init(){
        
    }
    
    // Initialise the scale with values.
    init(name: String, formula: [String], thePassingInterval: String) {
       
        scaleName = name
        scaleFormula = formula
        passingInterval = thePassingInterval
    
        // In Swift you must initialize all your variables before attempting to initialize the Super Class. 
        // super.init()
    }
    
    // Get the passingIndex
    func getPassingInterval()-> String {
        return passingInterval
    }
    
    func getScaleName()->String {
        return scaleName
    }
    
    func getFormula()->[String] {
        return scaleFormula
    }
    
    
    
    
    
}