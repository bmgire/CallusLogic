//  Copyright © 2016 Gire. All rights reserved.
//
//  This document will implement all saving and undo capabilities.
// After I get the mechanics of the fretboard builder working. 

import Cocoa

class Document: NSDocument, NSWindowDelegate {
    
    let mainWindowController = MainWindowController()
    

    //##########################################################
    // NSDocument auto generated override functions
    //##########################################################
    override init() {
        super.init()

    }
   
    //##########################################################
    override func makeWindowControllers() {
        // create and add your window controller.
        //let mainWindowController = MainWindowController()
        addWindowController(mainWindowController)
    }
    
    //##########################################################
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    //##########################################################
    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        
        
        // I'm ignoring errors. 
        
        // end editing for nothing.
       mainWindowController.window?.endEditingFor(nil)
        
        // Create an NSDataObject from the mainWindowControllers fretboardModelArray
        // old.... =  return NSKeyedArchiver.archivedDataWithRootObject(mainWindowController.getCurrentFretboardModel())
        return NSKeyedArchiver.archivedDataWithRootObject(mainWindowController.getFretboardModelArray())
        
        //throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    //##########################################################
    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        
        print("About to read data of type \(typeName).");
        mainWindowController.setFretboardModelArray(NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [FretboardModel])
        
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
       // throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
}

