//
//  FretboardModel.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 5/7/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class FretboardModel: NSObject {

    let LENGTHOFCHROMATIC = 12

    let allIntervals = AllIntervals()
    let allScales = AllScales()
    
    var masterRoot: String?
    
    var unorderedScaleArray: [NoteModel]?
    var orderedScaleArray: [NoteModel]?
    var fullFretboardArray: [NoteModel]?
    
    var indexOfE: Int?
    
    func updateWithValues(root: String, accidental: String, scaleName: String) {
        if scaleName != "" {
        // builds masterNotesArray with appropriate notes.
        resolveRoot(root, accidental: accidental)
        getScaleAndOffset(allScales.dictOfScales[scaleName]!, intervalDictForRoot: allIntervals.intervalDict[masterRoot!]!)
        buildFretboard(unorderedScaleArray!)
        }
    }
    
    func resolveRoot(root: String, accidental: String) {
        // If accidental, isn't "Natural", append it to the masterRoot.
        if accidental != "Natural" {
            var temp = root
            temp.appendContentsOf(accidental)
            masterRoot = temp
        }
        else {
            masterRoot = root
        }
    }
    
    func getScaleAndOffset(scale: Scale, intervalDictForRoot: [String:String]) {
        
        // Calculates the notes of the scale. 
    
        var interval: String = ""   // Holds the interval read from the scale
        var temp:[NoteModel] = []               // Temp array to hold fretboard model of notes.
                
        for index in 0...(LENGTHOFCHROMATIC - 1) {
            interval = scale.getFormula()[index]
            
            let note = NoteModel()      // variable to hold all notes.
            
            // If interval is blank, append blank space.
            if interval == "" {
                note.setNote(interval)
                temp.append(note)
            }
            // Else, interval defines a note, find note and append.
            else {
                note.setNote(intervalDictForRoot[interval]!)
                temp.append(note)
            }
        } // Ends for loop.
       
        // Find any passing notes and at parentheses
        if scale.hasPassingNote {
            temp[scale.passingIndex!].addParenthesesToPassingTone()
        }
        unorderedScaleArray = temp
        
        indexOfE = Int(intervalDictForRoot["indexOfE"]!)!
        
    }
    
    func buildFretboard(scale: [NoteModel]) {
        reorderAndLoadToFretboard(unorderedScaleArray!)
        fillFretboardWithNotes(orderedScaleArray!)
    }
    
    
    func reorderAndLoadToFretboard(unorderedScale: [NoteModel]){
        // if the Root isn't E, reorder.
        if indexOfE != 0 {
            // Create sub arrays of each range.
            let eToEnd: [NoteModel] = Array(unorderedScale[indexOfE!...(unorderedScale.endIndex - 1)])
            let rootUntilE: [NoteModel] = Array(unorderedScale[0..<indexOfE!])
            // Combine subarrays.
            orderedScaleArray = eToEnd + rootUntilE
        }
        else {
            orderedScaleArray = unorderedScale
        }
    }
    
    func fillFretboardWithNotes(orderedArray: [NoteModel]) {
        var temp: [NoteModel] = []
        for _ in 0...3 {
            temp.appendContentsOf(orderedScaleArray!)
        }
        
        // Remove last element to get the index count down to 46.
        temp.removeLast()
 
        fullFretboardArray = temp
    }
    
    func addNumbers() {
        
        for index in 0...46 {
           fullFretboardArray![index].number = String(index)
        }
    }
    
    
    
    
}
