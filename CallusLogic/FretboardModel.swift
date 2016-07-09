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
    
    var unorderedScaleArray: [String] = []
    var orderedScaleArray: [String] = []
    var fullFretboardArray: [NoteModel] = []
    
    var indexOfE: Int?
    
    
    
    
    func updateWithValues(root: String, accidental: String, scaleName: String) {
        if scaleName != "" {
        // builds masterNotesArray with appropriate notes.
        resolveRoot(root, accidental: accidental)
        getScaleAndOffset(allScales.dictOfScales[scaleName]!, intervalDictForRoot: allIntervals.intervalDict[masterRoot!]!)
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
    
    func getScaleAndOffset(scale: Scale, intervalDictForRoot: [String:String]) {
        
        // Calculates the notes of the scale. 
    
        var interval: String = ""   // Holds the interval read from the scale
        var temp:[String] = []               // Temp array to hold fretboard model of notes.
                
        for index in 0...(LENGTHOFCHROMATIC - 1) {
            interval = scale.getFormula()[index]
    
            // If interval is blank, append blank space.
            if interval == "" {
                temp.append(interval)
            }
            // Else, interval defines a note, find note and append.
            else {
                temp.append(intervalDictForRoot[interval]!)
                
            }
        } // Ends for loop.
       
        // Find any passing notes and add parentheses
        if scale.hasPassingNote {
            temp[scale.passingIndex!] = addParentheses(temp[scale.passingIndex!])
        }
        unorderedScaleArray = temp
        
        indexOfE = Int(intervalDictForRoot["indexOfE"]!)!
        
    }
    
    func addParentheses(theNote: String)-> String {
        var temp = "("
        temp = temp.stringByAppendingString(theNote)
        temp = temp.stringByAppendingString(")")
        return temp
    }

    
    func buildFretboard(scale: [String]) {
        reorderScale(unorderedScaleArray)
        buildNoteModels()
        addNoteNames(orderedScaleArray)
        buildNumbers()
    }
    
    
    
    func reorderScale(unorderedScale: [String]){
        // if the Root isn't E, reorder.
        if indexOfE != 0 {
            // Create sub arrays of each range.
            let eToEnd: [String] = Array(unorderedScale[indexOfE!...(unorderedScale.endIndex - 1)])
            let rootUntilE: [String] = Array(unorderedScale[0..<indexOfE!])
            // Combine subarrays.
            orderedScaleArray = eToEnd + rootUntilE
        }
        else {
            orderedScaleArray = unorderedScale
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
    
    
    func addNoteNames(orderedArray: [String]) {
        for octaveCount in 0...2{
            for scaleIndex in 0...11 {
                fullFretboardArray[scaleIndex + octaveCount * 12].setNote(orderedArray[scaleIndex])
                }
            }
        let octaveCount = 3
        for scaleIndex in 0...10 {
            fullFretboardArray[scaleIndex + octaveCount * 12].setNote(orderedArray[scaleIndex])
            
        }
    }
        

    
    func buildNumbers() {
        
        for index in 0...46 {
            if fullFretboardArray[index].note != "" {
            fullFretboardArray[index].number = String(index)
            }
        }
    }
    
    
    
    
}
