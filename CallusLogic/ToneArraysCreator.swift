//
//  ToneArraysCreator.swift
//  Callus Logic
//
//  Created by Ben Gire on 12/1/17.
//  Copyright © 2017 Gire. All rights reserved.
//

import Cocoa

class ToneArraysCreator {
/*
     
     NEW PLAN, just update ZeroTo46ToneCalculator, work work better, then create
     
     
    // let myRootToIntervalNotesDict = RootToIntervalNotes().getDictionaryGiveRootGetDictionaryOfNotesAndIntervals()
     let myScalesByIntervalsDict = ScalesByIntervals().getDictOfScales()
    
    // Both these number arrays are 61 elements long. With an extra octave on the bottom.
    fileprivate var zeroTo46Array = [String]()
    fileprivate var zeroTo11Array = [String]()
    
    fileprivate var intervalsArray = [String]()
    fileprivate var notesArray = [String]()
    
    // The offset used for E on the low-E string.
    fileprivate let OffsetOfLowE = 12
    
    //fileprivate var rootIntervalDict : [String : String] = [:]
    fileprivate var rootPlusAccidental = ""
    
    fileprivate var scale: Scale = Scale()
    
    
    //I'll need functions to update the intervals and notes arrays with the current user selected values.
    // I'll need a way to load these values into the current fretboard.
    
    
    init() {
        // These 2 arrays should never need to be updated.
        createZeroTo46Array()
        createZeroTo11Array()
        
        //Note, this leaves the IntervalsArray and NotesArray blank. see updateWithValues fcn
        
        
    }
    
     func updateWithValues(_ myRoot: String,
                                       myAccidental: String,
                                       scaleName: String,
                                      // displayMode: String,   // I'll likely just get rid of this
                                                                // not needed for every note.
                                       myCalcColor: NSColor) {
        
        // Combine Root with accidental
         combineRootAndAccidental(myRoot, accidental: myAccidental)
        
        // Find Scale intervals in the IntervalsOfScales Dictionary
        scale = myScalesByIntervalsDict[scaleName]!
        
        // Find the notes for each interval in the RootToIntervalNote dictionary
        
        // Create an array of ToneModels for each possible tone on the guitar. Note, Inverval, NoteNumbers.
        
        // Create an array of ToneModels for each possible tone on the guitar that is not in the scale.
        
        
        
    }
    
    
    
    fileprivate func createZeroTo46Array() {
        for index in -12...48 {
            zeroTo46Array.append(String(index))
        }
    }
    
    
    fileprivate func createZeroTo11Array() {
        for _ in 0...4 {
            for index in 0...11 {
                zeroTo11Array.append(String(index))
            }
        }
        // Needs to append extra.
        zeroTo11Array.append("0")
    }
    
    // Combine the root with the accidental (if necessary).
    fileprivate func combineRootAndAccidental(_ root: String, accidental: String) {
        // If accidental, isn't "Natural", append it to the masterRoot.
        if accidental != "Natural" {
            var temp = root
            temp.append(accidental)
            rootPlusAccidental = temp
        }
        else {
            rootPlusAccidental = root
        }
        
    }
    
    // Find the notes for each interval in the RootToIntervalNote dictionary
    
    
    
  */
}

