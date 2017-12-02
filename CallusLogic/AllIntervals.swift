//
//  AllIntervals.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 5/5/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

open class AllIntervals: NSObject {
    
    
    fileprivate var aFlat,  a,  aSharp,
        bFlat,  b,  bSharp,
        cFlat,  c,  cSharp,
        dFlat,  d,  dSharp,
        eFlat,  e,  eSharp,
        fFlat,  f,  fSharp,
        gFlat,  g,  gSharp: [String]

    // A dictionary where keys are strings and values are dictionaries. 
    fileprivate var intervalDict:[String : [String : String]] = [:]
    
    fileprivate var arrayOfIntervalDicts: [[String : String]] = []
    
    fileprivate var arrayOfRootNotes: [String]
    
    fileprivate var arrayOfIntervalNames:[String]
    
    fileprivate var arrayOfRootIntervals: [[String]]
    

    
    override init() {
    
    // Guide
    //             0       1         2       3      4        5       6        7       8       9       10       11     12       13      14      15      16      17      18      19
    //           root      m2        M2      A2     m3      M3       D4      P4      A4       D5      P5       A5     D6       m6      M6      A6      D7      m7      M7	   offset
        aFlat = ["Ab",   "Bbb",   "Bb",    "B",    "Cb",   "C",    "Dbb",   "Db",   "D",   "Ebb",   "Eb",    "E",   "Fbb",   "Fb",    "F",   "F#",   "Gbb",    "Gb",   "G",    "8"]
     
            a = ["A",    "Bb",    "B",     "B#",	"C",   "C#",   "Db",    "D",    "D#",   "Eb",   "E",     "E#",   "Fb",    "F",    "F#",  "F##",   "Gb",
                 "G",    "G#",   "7"]   
        
          aSharp =   [ "A#",    "B",     "B#",    "B##",	 "C#",    "C##",   "D",     "D#",    "D##",   "E",     "E#",    "E##",   "F",     "F#",    "F##",
                       "F###",  "G",     "G#",    "G##",   "6"]
        
          bFlat =   [ "Bb",    "Cb",    "C",		 "C#",	 "Db",    "D",     "Ebb",   "Eb",    "E",     "Fb",    "F",     "F#",    "Gbb",   "Gb",    "G",     "G#",
                      "Abb",   "Ab",    "A",     "6"]
          b =   [ "B",     "C",     "C#",    "C#",	 "D",     "D#",    "Eb",    "E",     "E#",    "F",     "F#",    "F##",   "Gb",    "G",     "G#",    "G##",   "Ab",
                  "A",     "A#",    "5"]
          bSharp =   [ "B#",    "C#",    "C##",   "C##",	 "D#",    "D##",   "E",     "E#",    "E##",   "F#",    "F##",   "F###",  "G",     "G#",    "G##",   "G###",
                       "A",     "A#",    "A##",   "4"]
        
          cFlat =   [ "Cb",    "Dbb",   "Db",    "D",		 "Ebb",   "Eb",    "Fbb",   "Fb",    "F",     "Gbb",   "Gb",    "G",     "G#",    "Abb",   "Ab",    "A",
                      "Bbbb",  "Bbb",   "Bb",    "5"]
          c =   [ "C",     "Db",    "D",     "D#",	 "Eb",    "E",     "Fb",    "F",     "F#",    "Gb",    "G",     "G#",    "G##",   "Ab",    "A",     "A#",    "Bbb",
                  "Bb",    "B",     "4"]
          cSharp =   [ "C#",    "D",     "D#",    "D##",   "E",		 "E#",	 "F",     "F#",    "F##",   "G",     "G#",    "G##",   "G###",  "A",     "A#",    "A##",
                       "Bb",    "B",     "B#",    "3"]
        
          dFlat =   [ "Db",    "Ebb",   "Eb",    "E",		 "Fb",    "F",     "Gbb",   "Gb",    "G",     "Abb",   "Ab",    "A",     "Bbbb",  "Bbb",   "Bb",    "B",
                      "Cbb",   "Cb",    "C",     "3"]
          d =   [ "D",     "Eb",    "E",     "E#",	 "F",     "F#",    "Gb",    "G",     "G#",    "Ab",    "A",     "A#",    "Bbb",   "Bb",    "B",     "B#",    "Cb",
                  "C",     "C#",    "2"]
          dSharp =   [ "D#",    "E",     "E#",    "E##",	 "F#",    "F##",   "G",     "G#",    "G##",   "A",     "A#",    "A##",   "Bb",    "B",     "B#",    "B##",
                       "C",     "C#",    "C##",   "1"]
        
          eFlat =   [ "Eb",    "Fb",    "F",     "F#",	 "Gb",    "G",     "Abb",   "Ab",    "A",     "Bbb",   "Bb",    "B",     "Cbb",   "Cb",    "C",     "C#",
                      "Dbb",    "Db",    "D",     "1"]
          e =   [ "E",     "F",     "F#",    "F##",	 "G",     "G#",    "Ab",    "A",     "A#",    "Bb",    "B",     "B#",    "Cb",    "C",     "C#",    "C##",   "Db",
                  "D",     "D#",    "0"]
          eSharp =   [ "E#",    "F#",    "F##",   "F###",	 "G#",    "G##",   "A",     "A#",    "A##",   "B",     "B#",    "B##",   "C",     "C#",    "C##",   "C###",
                       "D",     "D#",    "D##",   "11"]
        
          fFlat =    [ "Fb",    "Gbb",   "Gb",    "G",		 "Abb",   "Ab",    "Bbbb",  "Bbb",   "Bb",    "Cbb",   "Cb",    "C",     "Dbbb",  "Dbb",   "Db",    "D",
                       "Ebbb",  "Ebb",   "Eb",    "0"]
          f =    [ "F",     "Gb",    "G",     "G#",	 "Ab",    "A",     "Bbb",   "Bb",    "B",     "Cb",    "C",     "C#",    "Dbb",   "Db",    "D",     "D#",    "Ebb",
                   "Eb",    "E",     "11"]
          fSharp =    [ "F#",    "G",     "G#",    "G##",	 "A",     "A#",    "Bb",    "B",     "B#",    "C",     "C#",    "C##",   "Db",    "D",     "D#",    "D##",
                        "Eb",    "E",     "E#",    "10"]
        
          gFlat =    [ "Gb",    "Abb",   "Ab",    "A",		 "Bbb",   "Bb",    "Cbb",   "Cb",    "C",     "Dbb",   "Db",    "D",     "Ebbb",  "Ebb",   "Eb",    "E",
                       "Fbb",   "Fb",    "F",     "10"]
          g =    [ "G",     "Ab",    "A",     "A#",	 "Bb",    "B",     "Cb",    "C",     "C#",    "Db",    "D",     "D#",    "Ebb",   "Eb",    "E",     "E#",    "Fb",
                   "F",     "F#",    "9"]
          gSharp =    [ "G#",    "A",     "A#",    "A##",	 "B",     "B#",    "C",     "C#",    "C##",   "D",     "D#",    "D##",   "Eb",    "E",     "E#",    "E##",
                        "F",     "F#",    "F##",   "8"]

        
        
        
        arrayOfRootNotes = [ "Ab",  "A",  "A#",
                             "Bb",  "B",  "B#",
                             "Cb",  "C",  "C#",
                             "Db",  "D",  "D#",
                             "Eb",  "E",  "E#",
                             "Fb",  "F",  "F#",
                             "Gb",  "G",  "G#"]   
        
        //Note = the indexOfE pertains to half steps above the root within an octave.
        // many intervals represent the same tone (ex: A2 & m3)
        arrayOfIntervalNames =  ["root", "m2",  "M2", "A2", "m3",  "M3", "D4", "P4", "A4",  "D5", "P5", "A5", "D6", "m6", "M6", "A6", "D7", "m7" ,"M7",	"indexOfE"]
        
        
        
        // init
        arrayOfRootIntervals = [aFlat,   a,   aSharp,
                                bFlat,   b,   bSharp,
                                cFlat,   c,   cSharp,
                                dFlat,   d,   dSharp,
                                eFlat,   e,   eSharp,
                                fFlat,   f,   fSharp,
                                gFlat,   g,   gSharp]
        
        // temp array, each member is a dictionary holding 1 intervalArray with it's associated root.
        var temp:[[String:String]] = []
        
        // Using each root-specific interval array, create a dictionary matching each note name with the appropriate interval.
        // and add that dictionary to an array.
        
        for index in 0...20 {
        
        temp.append(NSDictionary.init(objects: arrayOfRootIntervals[index], forKeys: arrayOfIntervalNames as [NSCopying]) as! [String : String])
        }
        // Pointer Swap.
        arrayOfIntervalDicts = temp
        
        // Pointer swap.
        intervalDict = NSDictionary.init(objects: arrayOfIntervalDicts, forKeys: arrayOfRootNotes as [NSCopying]) as! [String : [String : String]]
        super.init()
    }
    
    func getIntervalsDict()->[String : [String : String]] {
        return intervalDict
    }
}
