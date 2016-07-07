//
//  AllScales.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 5/1/16.
//  Copyright © 2016 Gire. All rights reserved.
//

// Attempting not to import cocoa.
import Cocoa

class AllScales: NSObject {
    
    var dictOfScales: [String: Scale] = [:]
    
    // Arrays to hold scales and scale names
    var scaleArray: [Scale] = []
    var keyArray: [String] = []
    
    override init() {
        // super.init() must be called before calling any functions within self.
        super.init()
        
        // Call to private member function that builds a scale and key.
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name: "Minor Pentatonic", formula: ["root", "", "", "m3", "", "P4", "D5", "P5","","", "m7", "", "offset"], passingNoteIndex: 6))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name: "Major Pentatonic", formula: [ "root",  "",   "M2", "m3", "M3", "",   "", "P5",  "", "M6",  "",  "",  "offset"], passingNoteIndex: 3))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Ionian", formula:  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "",    "M6",  "",    "M7",  "offset"], passingNoteIndex: -1))
        
      
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Dorian", formula:  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "",	  "M6",  "m7",  "",    "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Phryian", formula:  [ "root",   "m2",  "",		 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "m7",  "",    "offset"], passingNoteIndex: -1))
       
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Lydian", formula:  [ "root",   "",    "M2",	 "",    "M3",  "",    "A4",   "P5",  "",    "M6",  "",    "M7",  "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "MixoLydian", formula:  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "",    "M6",  "m7",  "",    "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Aeolian", formula:  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "m7",  "",    "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Locrian", formula:  [ "root",   "m2",  "",		 "m3",  "",    "P4",  "D5",   "",    "m6",  "",    "m7",  "",    "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Harmonic Minor", formula:  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "",    "M7",  "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Harmonic Major", formula:  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "m6",  "",    "",    "M7",  "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Hungarian Minor", formula:  [ "root",     "",    "M2",   "m3",    "",  "",  "A4",     "P5",    "m6",    "",  "",    "M7",  "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Phrygian Dominant", formula:  [ "root",   "m2",  "",     "",    "M3",  "P4",  "",     "P5",    "m6",    "",  "m7",    "",  "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "Persian", formula:  [ "root",   "m2",  "",     "",    "M3",  "P4",  "D5",     "",    "m6",    "",  "",    "M7",  "offset"], passingNoteIndex: -1))
        
        buildAndAddScale(&scaleArray,
                         keyArray: &keyArray,
                         aScale: Scale(name:  "All Notes", formula:  [ "root", "m2", "M2", "m3",  "M3",  "P4",  "D5",  "P5",    "m6",    "M6",  "m7",    "M7",  "offset"], passingNoteIndex: -1))
        
        
        // Add all built scales to a temp dictionary.
        let tempDict: [String : Scale] = NSDictionary.init(objects: scaleArray, forKeys: keyArray) as! [String : Scale]
        
        // Pointer swap with tempDict.
        dictOfScales = tempDict
    }
    
    
    func buildAndAddScale(inout scaleArrayArray:[Scale],inout keyArray: [String], aScale: Scale) {
        scaleArray.append(aScale)
        keyArray.append(aScale.getScaleName())
    }
    
    
}



//        //     0      1    2       3     4       5       6      7     8     9      10     11      12
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:  "Minor Pentatonic":  [ "root",   "",    "",		 "m3",  "",    "P4",  "D5",   "P5",	 "",	  "",    "m7",  "",    "offset"] :6]];

//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:  "Major Pentatonic":  [ "root",   "",    "M2",	 "m3",  "M3",  "",    "",     "P5",  "",    "M6",  "",    "",    "offset"] :3]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:           "Ionian" :  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "",    "M6",  "",    "M7",  "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:           "Dorian" :  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "",	  "M6",  "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:          "Phryian" :  [ "root",   "m2",  "",		 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:           "Lydian" :  [ "root",   "",    "M2",	 "",    "M3",  "",    "A4",   "P5",  "",    "M6",  "",    "M7",  "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:       "MixoLydian" :  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "",    "M6",  "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:          "Aeolian" :  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:          "Locrian" :  [ "root",   "m2",  "",		 "m3",  "",    "P4",  "D5",   "",    "m6",  "",    "m7",  "",    "offset"] :-1]];
//        




//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:   "Harmonic Minor" :  [ "root",   "",    "M2",	 "m3",  "",    "P4",  "",     "P5",  "m6",  "",    "",    "M7",  "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:   "Harmonic Major" :  [ "root",   "",    "M2",	 "",    "M3",  "P4",  "",     "P5",  "m6",  "",    "",    "M7",  "offset"] :-1]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:  "Hungarian Minor" :  [ "root",     "",    "M2",   "m3",    "",  "",  "A4",     "P5",    "m6",    "",  "",    "M7",  "offset"] :-1]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:  "Phrygian Dominant":  [ "root",   "m2",  "",     "",    "M3",  "P4",  "",     "P5",    "m6",    "",  "m7",    "",  "offset"] :-1]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:           "Persian" :  [ "root",   "m2",  "",     "",    "M3",  "P4",  "D5",     "",    "m6",    "",  "",    "M7",  "offset"] :-1]];
//  



//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:   "Major Arpeggio" :  [ "root",   "",    "",		 "",    "M3",  "",    "",     "P5",  "",	  "",    "",    "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:   "Maj#5 Arpeggio" :  [ "root",   "",    "",		 "",    "M3",  "",    "",     "",	 "A5",  "",    "",    "",    "offset"] :-1]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:	    "6 Arpeggio" :  [ "root",   "",    "",		 "",    "M3",   "",   "",     "P5",  "",    "M6",  "",	 "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:      "m6 Arpeggio" :  [ "root",   "",    "",		 "m3",  "",		 "",   "",     "P5",  "",    "M6",  "",	 "",    "offset"] :-1]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:    "Maj7 Arpeggio" :  [ "root",   "",    "",		 "",    "M3",	 "",    "",     "P5",  "",		 "",    "",    "M7",  "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:   "Minor Arpeggio" :  [ "root",   "",    "",		 "m3",  "",		 "",    "",     "P5",  "",		 "",    "",    "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:     "m#5 Arpeggio" :  [ "root",   "",    "",		 "m3",    "",	 "",    "",     "",	  "A5",	 "",    "",    "",    "offset"] :-1]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:      "m7 Arpeggio" :  [ "root",   "",    "",		 "m3",  "",		 "",    "",     "P5",  "",    "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:    "m7b5 Arpeggio" :  [ "root",   "",    "",		 "m3",  "",		 "",    "D5",   "",	 "",    "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:    "dim7 Arpeggio" :  [ "root",   "",    "",		 "m3",  "",		 "",    "D5",   "",	 "",    "D7",  "",    "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:     "7th Arpeggio" :  [ "root",   "",    "",		 "",    "M3",	 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:     "7#5 Arpeggio" :  [ "root",   "",    "",		 "",    "M3",	 "",	 "",     "",    "A5",  "",    "m7",  "",    "offset"] :-1]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:    "Maj9 Arpeggio" :  [ "root",   "",    "M2",	 "",    "M3",  "",    "",     "P5",  "",	  "",    "",    "M7",  "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:      "m9 Arpeggio" :  [ "root",   "",    "M2",	 "m3",  "",		 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:     "9th Arpeggio" :  [ "root",   "",    "M2",	 "",    "M3",	 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:     "7#9 Arpeggio" :  [ "root",   "",    "",	    "A2",  "M3",	 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:     "7b9 Arpeggio" :  [ "root",   "m2",  "",		 "",    "M3",	 "",	 "",     "P5",  "",    "",    "m7",  "",    "offset"] :-1]];
//        
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:   "Maj11 Arpeggio" :  [ "root",   "",    "M2",	 "",    "M3",	 "",    "A4",    "P5",  "",	  "",    "",    "M7",  "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:     "m11 Arpeggio" :  [ "root",   "",    "M2",	 "m3",  "",		 "",    "A4",    "P5",  "",	  "",    "m7",  "",    "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:   "dim11 Arpeggio" :  [ "root",   "",    "M2",	 "",     "M3",	 "P4",   "",     "P5",   "",	  "",    "m7",  "",    "offset"] :4]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:      "Single Note" :  [ "root",   "",    "",       "",     "",	 "",     "",     "",     "",   "",  "",  "",  "offset"] :-1]];
//        [self buildAndAddScale:scaleArray :tempNames :[[Scale alloc]initWithVals:        "All Notes" :  [ "root",   "m2",  "M2",	 "m3",  "M3",	 "P4",  "A4",   "P5",  "m6",  "M6",  "m7",  "M7",  "offset"] :-1]];
        
