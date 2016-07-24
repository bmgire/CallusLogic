//
//  FretboardModel.swift
//  CallusLogic
//
//  Copyright © 2016 Gire. All rights reserved.
//  This model is not very accurate, I need for this to hold all the information of the

import Foundation


class FretboardModel: NSObject, NSCoding {
    
    var fretboardArray: [NoteModel]? = []
    
    var fretboardTitle: String? = ""
    
    var canCustomize = false
    
    // MARK:- Encoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let fretboardArray = fretboardArray {
            for index in 0...137 {
                aCoder.encodeObject(fretboardArray[index], forKey: "noteModel\(index)")
            }
        }
        if let fretboardTitle = fretboardTitle {
            aCoder.encodeObject(fretboardTitle, forKey: "fretboardTitle")
        }
        aCoder.encodeBool(canCustomize, forKey: "canCustomize")
    }
    
    required init?(coder aDecoder: NSCoder) {
        for index in 0...137 {
            if let noteModel = aDecoder.decodeObjectForKey("noteModel\(index)"){
                fretboardArray!.append(noteModel as! NoteModel)
            }
        }
        
        fretboardTitle = aDecoder.decodeObjectForKey("fretboardTitle") as! String?
        canCustomize = aDecoder.decodeBoolForKey("canCustomize")
        
        super.init()
        
    }
    
    func getFretboardArray()-> [NoteModel] {
        return fretboardArray!
    }
    
    func getFretboardTitle()-> String {
        return fretboardTitle!
    }

    
    
    override init(){
        super.init()
        
        if fretboardArray!.count == 0 {
        // Build 138 item array of NoteModels.
        var temp : [NoteModel] = []
        for _ in 0...137 {
            temp.append(NoteModel())
            }
            fretboardArray = temp
        }
    }
    

}

