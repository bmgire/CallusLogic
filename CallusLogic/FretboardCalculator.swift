//
//  FretboardCalculator.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 5/7/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class FretboardCalculator {

    //##########################################################
    // MARK: - Constants
    //##########################################################
    let LENGTHOFCHROMATIC = 12
    
    let myArrayOfIntervalDicts = AllIntervals().intervalDict
    let myDictOfScales = AllScales().dictOfScales
    
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    var masterRoot: String?
   
    var rootIntervalDict : [String : String] = [:]
    var scale: Scale = Scale()
    
    
    var unorderedIntervalsArray : [String] = []
    var orderedIntervalsArray: [String] = []
    var unorderedScaleArray: [String] = []
    var orderedScaleArray: [String] = []
    
    var indeciesOfNotes: [Int] = []
    //var indeciesOfSpaces: [Int] = []
    
    var intervalIndexOfE = 0
    var passingInterval = ""
    var fretArray: [NoteModel] = []
    
    //##########################################################
    // MARK: - Custom functions
    //##########################################################
    // Get the current user selected values and update the array of NoteModels.
    func updateWithValues(myRoot: String, myAccidental: String, scaleName: String) {
        if scaleName != "" {
            
            fretArray = FretboardModel().array
            
            resolveRoot(myRoot, accidental: myAccidental)
            // Find and save the Scale object.
            scale = myDictOfScales[scaleName]!
            
            rootIntervalDict = myArrayOfIntervalDicts[masterRoot!]!
            
            intervalIndexOfE = Int(rootIntervalDict["indexOfE"]!)!
            // Save the passing interval.
            passingInterval = scale.getPassingInterval()
            
           
            getScaleIntervalsAndIntervalOfE(scale, intervalDictForRoot: rootIntervalDict)
            buildFretboard(unorderedScaleArray)
        }
    }
    
    // Combine the root with the accidental, if necessary.
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
    
    // Gets the scale intervals and intervalofE
    func getScaleIntervalsAndIntervalOfE(scale: Scale, intervalDictForRoot: [String:String]) {
        var interval: String = ""
        var tempIntervals:[String] = []
        var tempScale:[String] = []
        
        // Find each value of the scale including blank non-notes..
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
        unorderedScaleArray = tempScale
        unorderedIntervalsArray = tempIntervals
        
       
    }
    
    // Reorder the scale and interval arrays, add numbers
    func buildFretboard(scale: [String]) {
        orderedScaleArray = reorderArray(unorderedScaleArray)
        orderedIntervalsArray = reorderArray(unorderedIntervalsArray)
        reorderArray(unorderedIntervalsArray)
        addNoteNamesIntervalsAndNumber0to11(orderedScaleArray, orderedIntervals: orderedIntervalsArray)
        addNumbers0to46()
        setPassingNotesForScale()
    }
    
    
    
    func reorderArray(unorderedArray: [String])-> [String]{
        // if the Root isn't E, reorder.
        if intervalIndexOfE != 0 {
            // Create sub arrays of each range.
            let eToEnd: [String] = Array(unorderedArray[intervalIndexOfE...(unorderedArray.endIndex - 1)])
            let rootUntilE: [String] = Array(unorderedArray[0..<intervalIndexOfE])
            // Combine subarrays.
            return eToEnd + rootUntilE
        }
        else {
            return unorderedArray
        }
    }
    
    func addNoteNamesIntervalsAndNumber0to11(orderedNotes: [String], orderedIntervals: [String]) {
        for octaveCount in 0...2{
            for scaleIndex in 0...11 {
                let fret = fretArray[scaleIndex + octaveCount * 12]
                //if fret.isKept == false {
                    fret.note = orderedNotes[scaleIndex]
                    fret.interval = orderedIntervals[scaleIndex]
                    fret.number0to11 = String(scaleIndex)
                //}
            }
        }
        let octaveCount = 3
        for scaleIndex in 0...10 {
            let fret = fretArray[scaleIndex + octaveCount * 12]
            
            fret.note = orderedNotes[scaleIndex]
            fret.interval = orderedIntervals[scaleIndex]
            fret.number0to11 = String(scaleIndex)
        }
    }
    
    func addNumbers0to46() {
        var temp: [Int] = []
        for index in 0...46 {
            if  fretArray[index].note != "" {
                fretArray[index].number0to46 = String(index)
                fretArray[index].isInscale = true
                fretArray[index].isGhost = false
                fretArray[index].isDisplayed = true
                temp.append(index)
            }
        }
        indeciesOfNotes = temp
    }
    
    func setPassingNotesForScale() {
        if passingInterval != ""{
            let passingIndex = orderedIntervalsArray.indexOf(passingInterval)
            for index in 0...2 {
               fretArray[index * 12 + passingIndex!].isPassingNote = true
            }
       
        }
    }
    
//    func resetUnkeptNotes() {
//        for index in 0...46 {
//            if fretArray[index].isKept == false {
//                fretArray[index].resetProperties()
//            }
//        }
//    }
    

}
