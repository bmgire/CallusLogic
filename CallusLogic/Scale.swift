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
    private var scaleName: String = ""
    private var scaleFormula: [String] = []
    private var passingInterval = ""
    
    init(){
        
    }
    
    // Initialise the scale with values.
    init(name: String, formula: [String], thePassingInterval: String) {
       
        scaleName = name
        scaleFormula = formula
        passingInterval = thePassingInterval
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