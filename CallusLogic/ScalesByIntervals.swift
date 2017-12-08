//
//  AllScales.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 5/1/16.
//  Copyright © 2016 Gire. All rights reserved.
//

// Attempting not to import cocoa.
import Cocoa

class ScalesByIntervals {
    
    fileprivate var dictOfScales: [String: Scale] = [:]
    
    // Arrays to hold scales and scale names
    fileprivate var scaleArray: [Scale] = []
    fileprivate var keyArray: [String] = []
    
    init() {
    
    
/*
        // Call to private member function that builds a scale and key.
        buildAndAddScale(aScale: Scale(name:  "Root",
                                       formula: [ "root",   "",    "",       "",     "",     "",     "",     "",     "",   "",  "",  "",  "offset"],
                                       thePassingInterval: "" ))
*/
        
        
        // Call to private member function that builds a scale and key.
        buildAndAddScale(aScale: Scale(name:  "Root",
                            formula: [ "root",   "",    "",       "",     "",	 "",     "",     "",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))

        buildAndAddScale(aScale: Scale(name:  "Root and m2",
                            formula: [ "root",   "m2",    "",       "",     "",	 "",     "",     "",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        buildAndAddScale(aScale: Scale(name:  "Root and M2",
                            formula: [ "root",   "",    "M2",       "",     "",	 "",     "",     "",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and m3",
                            formula: [ "root",   "",    "",      "m3",     "",	 "",     "",     "",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and M3",
                            formula: [ "root",   "",    "",      "",     "M3",	 "",     "",     "",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and P4",
                            formula: [ "root",   "",    "",      "",     "",	 "P4",     "",     "",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and A4",
                            formula: [ "root",   "",    "",      "",     "",	 "",     "A4",     "",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and D5",
                            formula: [ "root",   "",    "",      "",     "",	 "",     "D5",     "",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and P5",
                            formula: [ "root",   "",    "",      "",     "",	 "",     "",     "P5",     "",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and A5",
                            formula: [ "root",   "",    "",      "",     "",	 "",     "",     "",     "A5",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and m6",
                            formula: [ "root",   "",    "",      "",     "",	 "",     "",     "",     "m6",   "",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and M6",
                            formula: [ "root",   "",    "",      "",     "",	 "",     "",     "",     "",   "M6",  "",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and m7",
                            formula: [ "root",   "",    "",      "",     "",	 "",     "",     "",     "",   "",  "m7",  "",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Root and M7",
                            formula: [ "root",   "",    "",      "",     "",	 "",     "",     "",     "",   "",  "",  "M7",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Ionian Mode", formula:  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "",    "M6",  "",    "M7",  "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Dorian Mode", formula:  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "",	  "M6",  "m7",  "",    "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Phrygian Mode", formula:  [ "root",   "m2",  "",		 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "m7",  "",    "offset"], thePassingInterval: "" ))
       
        buildAndAddScale(aScale: Scale(name:  "Lydian Mode", formula:  [ "root",   "",    "M2",	 "",    "M3",  "",    "A4",   "P5",  "",    "M6",  "",    "M7",  "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "MixoLydian Mode", formula:  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "",    "M6",  "m7",  "",    "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Aeolian Mode", formula:  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "m7",  "",    "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Locrian Mode", formula:  [ "root",   "m2",  "",		 "m3",  "",    "P4",  "D5",   "",    "m6",  "",    "m7",  "",    "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name: "Minor Pentatonic Scale", formula: ["root", "", "", "m3", "", "P4", "D5", "P5","","", "m7", "", "offset"], thePassingInterval: "D5"))
        
        buildAndAddScale(aScale: Scale(name: "Major Pentatonic Scale", formula: [ "root",  "",   "M2", "m3", "M3", "",   "", "P5",  "", "M6",  "",  "",  "offset"], thePassingInterval: "m3"))
        
        buildAndAddScale(aScale: Scale(name:  "Harmonic Minor Scale", formula:  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "",    "M7",  "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Harmonic Major Scale", formula:  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "m6",  "",    "",    "M7",  "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Hungarian Minor Scale", formula:  [ "root",     "",    "M2",   "m3",    "",  "",  "A4",     "P5",    "m6",    "",  "",    "M7",  "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Phrygian Dominant Scale", formula:  [ "root",   "m2",  "",     "",    "M3",  "P4",  "",     "P5",    "m6",    "",  "m7",    "",  "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Persian Scale", formula:  [ "root",   "m2",  "",     "",    "M3",  "P4",  "D5",     "",    "m6",    "",  "",    "M7",  "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Chromatic Scale", formula:  [ "root", "m2", "M2", "m3",  "M3",  "P4",  "D5",  "P5",    "m6",    "M6",  "m7",    "M7",  "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "Major Arpeggio", formula: [ "root",   "",    "",		 "",    "M3",  "",    "",     "P5",  "",	  "",    "",    "",    "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name: "Minor Arpeggio" ,
                                       formula: [ "root",   "",    "",	 "m3",  "",		 "",    "",     "P5",  "",		 "",    "",    "",    "offset"],
                                       thePassingInterval: "" ))

        buildAndAddScale(aScale: Scale(name: "Maj#5 Arpeggio" , formula: [ "root",   "",    "",		 "",    "M3",  "",    "",     "",	 "A5",  "",    "",    "",    "offset"], thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name: "m#5 Arpeggio" ,
                            formula: [ "root",   "",    "",		 "m3",    "",	 "",    "",     "",	  "A5",	 "",    "",    "",    "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name: "6 Arpeggio" ,
                                    formula: [ "root",   "",    "",		 "",    "M3",   "",   "",     "P5",  "",    "M6",  "",	 "",    "offset"],
                           thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name: "m6 Arpeggio" ,
                            formula: [ "root",   "",    "",	 "m3",  "",		 "",   "",     "P5",  "",    "M6",  "",	 "",    "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name: "Maj7 Arpeggio",
                            formula: [ "root",   "",    "",	"",    "M3",	 "",    "",     "P5",  "",		 "",    "",    "M7",  "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "m7 Arpeggio",
                            formula: [ "root",   "",    "",		 "m3",  "",		 "",    "",     "P5",  "",    "",    "m7",  "",    "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name: "m7b5 Arpeggio",
                            formula: [ "root",   "",    "",  "m3",  "",		 "",    "D5",   "",	 "",    "",    "m7",  "",    "offset"],
                            thePassingInterval: "" ))
        buildAndAddScale(aScale: Scale(name:  "dim7 Arpeggio",
                            formula: [ "root",   "",    "",	 "m3",  "",		 "",    "D5",   "",	 "",    "D7",  "",    "",    "offset"],
                            thePassingInterval: "" ))
        
        buildAndAddScale(aScale: Scale(name:  "7th Arpeggio",
                            formula: [ "root",   "",    "",	 "",    "M3",	 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"],
                            thePassingInterval: "" ))

        
// I'm keeping these notes for when I add arpeggio extension past the octave. 
        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name: "7#5 Arpeggio",
//                            formula: [ "root",   "",    "",	 "",    "M3",	 "",	 "",     "",    "A5",  "",    "m7",  "",    "offset"],
//                            thePassingInterval: "" ))
//        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name:  "Maj9 Arpeggio",
//                            formula: [ "root",   "",    "M2",	 "",    "M3",  "",    "",     "P5",  "",	  "",    "",    "M7",  "offset"],
//                            thePassingInterval: "" ))
//        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name:  "m9 Arpeggio",
//                            formula: [ "root",   "",    "M2",	 "m3",  "",		 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"],
//                            thePassingInterval: "" ))
//        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name:  "9th Arpeggio",
//                            formula: [ "root",   "",    "M2",	 "",    "M3",	 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"],
//                            thePassingInterval: "" ))
//        
//        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name:  "7#9 Arpeggio",
//                            formula: [ "root",   "",    "",    "A2",  "M3",	 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"],
//                            thePassingInterval: "" ))
//        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name:  "7b9 Arpeggio",
//                            formula: [ "root",   "m2",  "",	 "",    "M3",	 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"],
//                            thePassingInterval: "" ))
//        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name:  "Maj11 Arpeggio",
//                            formula: [ "root",   "",    "M2",	 "",    "M3",	 "",    "A4",    "P5",  "",	  "",    "",    "M7",  "offset"],
//                            thePassingInterval: "" ))
//        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name:  "m11 Arpeggio",
//                            formula: [ "root",   "",    "M2",	 "m3",  "",		 "",    "A4",    "P5",  "",	  "",    "m7",  "",    "offset"],
//                            thePassingInterval: "" ))
//        
//        buildAndAddScale(&scaleArray,
//                         keyArray: &keyArray,
//                         aScale: Scale(name:  "dim11 Arpeggio",
//                            formula: [ "root",   "",    "M2",	 "",     "M3",	 "P4",   "",     "P5",   "",	  "",    "m7",  "",    "offset"],
//                            thePassingInterval: "" ))




 

        // Add all built scales to a temp dictionary.
        let tempDict: [String : Scale] = NSDictionary.init(objects: scaleArray, forKeys: keyArray as [NSCopying]) as! [String : Scale]
        
        // Pointer swap with tempDict.
        dictOfScales = tempDict
    }
    
    func getDictOfScales()-> [String: Scale] {
        return dictOfScales
    }
    
    func getScaleArray() -> [Scale] {
        return scaleArray
    }
    
 
    func buildAndAddScale(aScale: Scale) {
        scaleArray.append(aScale)
        keyArray.append(aScale.getScaleName())
    }
    
    
}




        
