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
    
    var unorderedIntervalsArray : [String] = []
    var orderedIntervalsArray: [String] = []
    var unorderedScaleArray: [String] = []
    var orderedScaleArray: [String] = []
    var fullFretboardArray: [NoteModel] = []
    
    var indexOfE: Int?
    
    
    
    
    func updateWithValues(root: String, accidental: String, scaleName: String) {
        if scaleName != "" {
        // builds masterNotesArray with appropriate notes.
        resolveRoot(root, accidental: accidental)
        getScaleAndIndexOfE(allScales.dictOfScales[scaleName]!, intervalDictForRoot: allIntervals.intervalDict[masterRoot!]!)
        buildFretboard(unorderedScaleArray)
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
    
    func getScaleAndIndexOfE(scale: Scale, intervalDictForRoot: [String:String]) {
        
        // Calculates the notes of the scale. 
    
        var interval: String = ""                  // Holds the interval read from the scale
        var tempIntervals:[String] = []
        var tempScale:[String] = []               // Temp array to hold fretboard model of notes.
                
        for index in 0...(LENGTHOFCHROMATIC - 1) {
            interval = scale.getFormula()[index]
            tempIntervals.append(interval)
            // If interval is blank, append blank space.
            if interval == "" {
                tempScale.append(interval)
            }
            // Else, interval defines a note, find note and append.
            else {
                tempScale.append(intervalDictForRoot[interval]!)
                }
            } // Ends for loop.
       
        // Find any passing notes and add parentheses
        if scale.hasPassingNote {
            tempScale[scale.passingIndex!] = addParentheses(tempScale[scale.passingIndex!])
        }
        unorderedScaleArray = tempScale
        unorderedIntervalsArray = tempIntervals
        
        indexOfE = Int(intervalDictForRoot["indexOfE"]!)!
        
    }
    
    func addParentheses(theNote: String)-> String {
        var temp = "("
        temp = temp.stringByAppendingString(theNote)
        temp = temp.stringByAppendingString(")")
        return temp
    }

    
    func buildFretboard(scale: [String]) {
        orderedScaleArray = reorderArray(unorderedScaleArray)
        orderedIntervalsArray = reorderArray(unorderedIntervalsArray)
        reorderArray(unorderedIntervalsArray)
        buildNoteModels()
        addNoteNamesIntervalsAndNumber0to11(orderedScaleArray, orderedIntervals: orderedIntervalsArray)
        addNumbers0to46()
    }
    
    
    
    func reorderArray(unorderedArray: [String])-> [String]{
        // if the Root isn't E, reorder.
        if indexOfE != 0 {
            // Create sub arrays of each range.
            let eToEnd: [String] = Array(unorderedArray[indexOfE!...(unorderedArray.endIndex - 1)])
            let rootUntilE: [String] = Array(unorderedArray[0..<indexOfE!])
            // Combine subarrays.
            return eToEnd + rootUntilE
        }
        else {
            return unorderedArray
        }
    }
    
    func buildNoteModels() {
        // Build 47 item array of NoteModels. 
        var temp : [NoteModel] = []
        
        for _ in 0...46 {
            temp.append(NoteModel())
            
        }
        fullFretboardArray = temp
    }
    
    
    func addNoteNamesIntervalsAndNumber0to11(orderedNotes: [String], orderedIntervals: [String]) {
        for octaveCount in 0...2{
            for scaleIndex in 0...11 {
                fullFretboardArray[scaleIndex + octaveCount * 12].note = orderedNotes[scaleIndex]
                fullFretboardArray[scaleIndex + octaveCount * 12].interval = orderedIntervals[scaleIndex]
                fullFretboardArray[scaleIndex + octaveCount * 12].number0to11 = String(scaleIndex)
                }
            }
        let octaveCount = 3
        for scaleIndex in 0...10 {
            fullFretboardArray[scaleIndex + octaveCount * 12].note = orderedNotes[scaleIndex]
            fullFretboardArray[scaleIndex + octaveCount * 12].interval = orderedIntervals[scaleIndex]
            fullFretboardArray[scaleIndex + octaveCount * 12].number0to11 = String(scaleIndex)
            
        }
    }
    
    func addNumbers0to46() {
        
        for index in 0...46 {
            if fullFretboardArray[index].note != "" {
                fullFretboardArray[index].number0to46 = String(index)
            }
        }
    }
    
//    func buildNumbers0to11() {
//        for octaveCount in 0...2{
//            for scaleIndex in 0...11 {
//                fullFretboardArray[scaleIndex + octaveCount * 12].number0to11 = String(scaleIndex)
//            }
//        }
//        let octaveCount = 3
//        for scaleIndex in 0...10 {
//            fullFretboardArray[scaleIndex + octaveCount * 12].number0to11 = String(scaleIndex)
//        }
//    }
}
