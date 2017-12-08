//
//  ToneArraysCreator.swift
//  Callus Logic
//
//  Created by Ben Gire on 12/1/17.
//  Copyright © 2017 Gire. All rights reserved.
//

import Cocoa

class ToneArraysCreator {
    
    // The goal is to make this class work to update the views instead of ZeroTo46Calculator Tone Arrays.
    
    
    //################### Constants ########################
    let giveScaleGetIntervalsDict = ScalesByIntervals().getDictOfScales()
    let giveRootGetIntervalToNotesDict = RootToIntervalNotes().getDictionaryGiveRootGetDictionaryOfNotesAndIntervals()
    let LENGTH_OF_CHROMATIC = 12
    
    //################### Variables ########################
    // Dictionary based off of root. Changes with every different root.
    fileprivate var giveIntervalGetNoteAboveRoot: [String : String] = [:]
    
    // Both these number arrays are 61 elements long. With room for an extra octave on the bottom.
    fileprivate var zeroTo46Array = [String]()
    fileprivate var zeroTo11Array = [String]()
    
    // Arrays below are updated with each scale added to the fretboard
    fileprivate var intervalsArray = [String]()
    fileprivate var notesArray = [String]()
    
    fileprivate var rootPlusAccidental = ""
    
    fileprivate var arrayOfScaleIntervals = [String]()
    
    fileprivate var indexOfE: Int = 0
    
    fileprivate var arrayOfToneArrays = [[String]]()
    
    //################### Functions ########################
    init() {
        // These 2 arrays should never need to be updated.
        createZeroTo46Array()
        createZeroTo11Array()
        
        //Note, this leaves the IntervalsArray and NotesArray blank. see updateWithValues fcn
    }
    
    //###################
    func updateWithValues(_ myRoot: String,
                          myAccidental: String,
                          scaleName: String) {
        
        // Combine Root with accidental
        combineRootAndAccidental(myRoot, accidental: myAccidental)
        
        // Find Scale intervals in the IntervalsOfScales Dictionary
        arrayOfScaleIntervals = giveScaleGetIntervalsDict[scaleName]!.getFormula()
        
        // Find the notes for each interval in the RootToIntervalNote dictionary
        giveIntervalGetNoteAboveRoot = giveRootGetIntervalToNotesDict[rootPlusAccidental]!
        
        // Get index of e above the root.
        indexOfE = Int(giveIntervalGetNoteAboveRoot["indexOfE"]!)!
        
        // Build note and interval arrays.
        buildIntervalsArray()
        buildNotesArray()
        //Build array that holds all note, interval, and number arrays.
        buildArraysOfToneArrays()
    }
    
    func getArrayOfToneArrays()->[[String]] {
        return arrayOfToneArrays
    }
    
    //###################
    fileprivate func createZeroTo46Array() {
        for index in -12...48 {
            zeroTo46Array.append(String(index))
        }
    }
    
    //###################
    fileprivate func createZeroTo11Array() {
        for _ in 0...4 {
            for index in 0...11 {
                zeroTo11Array.append(String(index))
            }
        }
        // Needs to append extra.
        zeroTo11Array.append("0")
    }
    
    //###################
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
    
    //###################
    fileprivate func buildIntervalsArray() {
        // Copy array of intervals.
        var array = arrayOfScaleIntervals
        //remove the offset dummy interval... which I don't know if we even need.
        array.remove(at: LENGTH_OF_CHROMATIC)
        // Reorder
        array = reorderArray(array)
        //Lengthen
        intervalsArray = lengthenArray(array)
    }
    //###################
    fileprivate func buildNotesArray() {
        var array = [String]()
        for index in 0...11 {
            let interval = arrayOfScaleIntervals[index]
            let  note = giveIntervalGetNoteAboveRoot[interval]!
            array.append(note)
        }
        array = reorderArray(array)
        notesArray = lengthenArray(array)
    }
    
    //###################
    fileprivate func reorderArray(_ unordered: [String]) ->[String] {
        if indexOfE != 0 {
            // Create sub arrays of each range.
            let eToEnd: [String] = Array(unordered[indexOfE...(unordered.endIndex - 1)])
            let rootUntilE: [String] = Array(unordered[0..<indexOfE])
            // Combine subarrays.
            return eToEnd + rootUntilE
        }
            // No Reordering necessary.
        else {
            return unordered
        }
    }
    
    //###################
    fileprivate func lengthenArray(_ short: [String])-> [String] {
        // Copy the array.
        var lengthen = short
        // Make that copy longer.
        for _ in 0...3 {
            lengthen += short
        }
        // Add 1 extra element to the array.
        lengthen.append(short[0])
        
        return lengthen
    }
    
    fileprivate func buildArraysOfToneArrays(){
        var temp = [[String]]()
        temp.append(zeroTo11Array)
        temp.append(zeroTo46Array)
        temp.append(notesArray)
        temp.append(intervalsArray)
        
        arrayOfToneArrays = temp
    }
    
    
}

