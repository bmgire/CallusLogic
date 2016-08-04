//
//  FretboardModel.swift
//  CallusLogic
//
//  Copyright © 2016 Gire. All rights reserved.
//  This holds all the setting for creating a Fretboard. 

import Cocoa


class FretboardModel: NSObject, NSCoding {
    
    
    //##########################################################
    // MARK: - Variables
    //##########################################################
    
    // The array of noteModels that make up the fretboard.
    private var fretboardArray: [NoteModel]? = []
    
    // The fretboards Title
    private var fretboardTitle: String? = "Untitled"
    
    // Whether the fretboard is locked for editing.
    private var isLocked = 0
    
    // The userColor for note selection.
    private var userColor: NSColor? = NSColor.yellowColor()
    
    private var itemImage: NSImage? = NSImage()

    
    //##########################################################
    // MARK: - Encoding
    //##########################################################
    // MARK:- Encoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        // Encode fretboardArray.
        if let fretboardArray = fretboardArray {
            for index in 0...137 {
                aCoder.encodeObject(fretboardArray[index], forKey: "noteModel\(index)")
            }
        }
        // Encode fretboardTitle.
        if let fretboardTitle = fretboardTitle {
            aCoder.encodeObject(fretboardTitle, forKey: "fretboardTitle")
        }
        // Encode userColor.
        if let userColor = userColor {
            aCoder.encodeObject(userColor, forKey: "userColor")
        }
        // Encode isLocked.
        aCoder.encodeInteger(isLocked, forKey: "isLocked")
        
        if let itemImage = itemImage {
            aCoder.encodeObject(itemImage, forKey: "itemImage")
        }
        
        
    }
    
    //##########################################################
    // MARK: - Decoding
    //##########################################################
    required init?(coder aDecoder: NSCoder) {
        
        // Decode fretboardArray
        for index in 0...137 {
            if let noteModel = aDecoder.decodeObjectForKey("noteModel\(index)"){
                fretboardArray!.append(noteModel as! NoteModel)
            }
        }
        
        // Decode fretboardTitle
        fretboardTitle = aDecoder.decodeObjectForKey("fretboardTitle") as! String?
        
        userColor = aDecoder.decodeObjectForKey("userColor") as! NSColor?
        
        // Decode isLocked.
        isLocked = aDecoder.decodeIntegerForKey("isLocked")
        
        itemImage = aDecoder.decodeObjectForKey("itemImage") as! NSImage?
        
        super.init()
    }
    
    //##########################################################
    // MARK: - Getters and Setters.
    //##########################################################
    func getFretboardArray()-> [NoteModel] {
        return fretboardArray!
    }
    
    func getFretboardTitle()-> String {
        return fretboardTitle!
    }
    
    func setFretboardTitle(newTitle: String) {
        fretboardTitle = newTitle
    }
    
    func getUserColor()-> NSColor {
        return userColor!
    }
    
    func setUserColor(newColor: NSColor) {
        userColor = newColor
    }
    
    func setIsLocked(state: Int) {
        isLocked = state
    }
    func getIsLocked()-> Int {
        return isLocked
    }
    
    func setItemImage(newImage: NSImage) {
        itemImage = newImage
    }
    
    func getItemImage()-> NSImage {
        return itemImage!
    }
    

    
    // Reqiured init.
    override init(){
        super.init()
        
        // If no encoded fretboardModel was loaded, build a fretboard model.
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

