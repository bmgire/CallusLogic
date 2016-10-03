//  Copyright © 2016 Gire. All rights reserved.
//  This calculates a fretboard scale or arpeggio and fills a fretboard model with it.


import Cocoa
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ZeroTo46ToneCalculator {

    //##########################################################
    // MARK: - Constants
    //##########################################################
    let LENGTHOFCHROMATIC = 12
    
    let myArrayOfIntervalDicts = AllIntervals().getIntervalsDict()
    let myDictOfScales = AllScales().getDictOfScales()
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    fileprivate var masterRoot = ""
    fileprivate var myDisplayMode = ""
    fileprivate var calcColor: NSColor?
    
    //private var ghost: Bool?
    fileprivate var rootIntervalDict : [String : String] = [:]
    fileprivate var scale: Scale = Scale()
    
    // Used for calculating and properly ordering a scale.
    fileprivate var unorderedIntervalsArray : [String] = []
    fileprivate var orderedIntervalsArray: [String] = []
    fileprivate var unorderedScaleArray: [String] = []
    fileprivate var orderedScaleArray: [String] = []
    
    fileprivate var indeciesOfNotes: [Int] = []
    
    fileprivate var intervalIndexOfE = 0
    fileprivate var passingInterval = ""
    fileprivate var zeroTo46ToneArray: [NoteModel] = []
    
    
    
    func getZeroTo46ToneArray()->[NoteModel] {
        return zeroTo46ToneArray
    }
    
    //##########################################################
    // MARK: - Custom functions
    //##########################################################
    // Get the current user selected values and update the array of NoteModels.
    func updateWithValues(_ myRoot: String,
                          myAccidental: String,
                          scaleName: String,
                          displayMode: String,
                          myCalcColor: NSColor)
                          /*selectNotes: String)*/  {
        if scaleName != "" {
            
            buildzeroTo46ToneArray()
            
            resolveRoot(myRoot, accidental: myAccidental)
            // Find and save the Scale object.
            scale = myDictOfScales[scaleName]!
            
            myDisplayMode = displayMode
            
            calcColor = myCalcColor
            
//            if selectNotes == "Select" {
//                ghost = false
//            }
//            else {
//                ghost = true
//            }
            rootIntervalDict = myArrayOfIntervalDicts[masterRoot]!
            
            intervalIndexOfE = Int(rootIntervalDict["indexOfE"]!)!
            // Save the passing interval.
            passingInterval = scale.getPassingInterval()
            
           
            getScaleIntervalsAndIntervalOfE(scale, intervalDictForRoot: rootIntervalDict)
            buildFretboard(unorderedScaleArray)
        }
    }
    
    // Combine the root with the accidental, if necessary.
    func resolveRoot(_ root: String, accidental: String) {
        // If accidental, isn't "Natural", append it to the masterRoot.
        if accidental != "Natural" {
            var temp = root
            temp.append(accidental)
            masterRoot = temp
        }
        else {
            masterRoot = root
        }
        
    }
    
    // Gets the scale intervals and intervalofE
    func getScaleIntervalsAndIntervalOfE(_ scale: Scale, intervalDictForRoot: [String:String]) {
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
    func buildFretboard(_ scale: [String]) {
        orderedScaleArray = reorderArray(unorderedScaleArray)
        orderedIntervalsArray = reorderArray(unorderedIntervalsArray)
        reorderArray(unorderedIntervalsArray)
        addNoteNamesIntervalsAndNumber0to11(orderedScaleArray, orderedIntervals: orderedIntervalsArray)
        addNumbers0to46()
        setPassingNotesForScale()
    }
    
    func reorderArray(_ unorderedArray: [String])-> [String]{
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
    
    func addNoteNamesIntervalsAndNumber0to11(_ orderedNotes: [String], orderedIntervals: [String]) {
        for octaveCount in 0...2{
            for scaleIndex in 0...11 {
                let noteModel = zeroTo46ToneArray[scaleIndex + octaveCount * 12]
                    noteModel.setNote(orderedNotes[scaleIndex])
                    noteModel.setInterval(orderedIntervals[scaleIndex])
                    noteModel.setNumber0to11(String(scaleIndex))
            }
        }
        let octaveCount = 3
        for scaleIndex in 0...10 {
            let noteModel = zeroTo46ToneArray[scaleIndex + octaveCount * 12]
            noteModel.setNote(orderedNotes[scaleIndex])
            noteModel.setInterval(orderedIntervals[scaleIndex])
            noteModel.setNumber0to11(String(scaleIndex))
            
        }
    }
    
    func addNumbers0to46() {
        var temp: [Int] = []
        for index in 0...46 {
            let model = zeroTo46ToneArray[index]
            
            // The the noteModel is in the scale.
            if  model.getNote() != "" {
                model.setNumber0to46(String(index))
                //model.setIsKept(true)
                model.setIsInScale(true)
               // model.setIsGhost(ghost!)
                //model.setIsDisplayed(true)
                model.setDisplayMode(myDisplayMode)
                model.setMyColor(calcColor!)
                temp.append(index)
            }
        }
        indeciesOfNotes = temp
    }
    
    func setPassingNotesForScale() {
        if passingInterval != ""{
            let passingIndex = orderedIntervalsArray.index(of: passingInterval)
            // Make a passing tone in the first 3 octaves.
            for index in 0...2 {
               zeroTo46ToneArray[index * 12 + passingIndex!].makePassingNote(true)
            }
            // Adds the last passing note. Accounts for 22 fret guitar. 
            if passingIndex < 11 {
                zeroTo46ToneArray[36 + passingIndex!].makePassingNote(true)
            }
        }
    }
    
    func buildzeroTo46ToneArray() {
        var temp: [NoteModel] = []
        for _ in 0...46 {
            temp.append(NoteModel())
        }
        zeroTo46ToneArray = temp
    }
}
