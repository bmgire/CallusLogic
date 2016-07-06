//
//  Document.swift
//  CallusLogic
//
//  Created by Ben Gire on 7/6/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa


class Document: NSDocument, NSWindowDelegate {

//    //##########################################################
//    // Outlets
//    //##########################################################
//    // Outlets to popUps
//    @IBOutlet weak var rootPopUp: NSPopUpButton!
//    @IBOutlet weak var accidentalPopUp: NSPopUpButton!
//    @IBOutlet weak var scalePopUp: NSPopUpButton!
//    
//    
//    // Outlet to fretboardView.
//    @IBOutlet weak var fretboardView: FretboardView!
//    
//    
//    //##########################################################
//    // Actions
//    //##########################################################
//    @IBAction func updateRoot(sender: NSPopUpButton) {
//        updateFretboardModelAndViews()
//    }
//    
//    @IBAction func updateAccidental(sender: NSPopUpButton) {
//        updateFretboardModelAndViews()
//    }
//    
//    @IBAction func updateScale(sender: NSPopUpButton) {
//        updateFretboardModelAndViews()
//    }
//    
//    //##########################################################
//    // Vars
//    //##########################################################
//
//    // FretboardModel to update Strings.
//    var fretboardModel = FretboardModel()
    
    //##########################################################
    // NSDocument auto generated override functions
    //##########################################################
    override init() {
        super.init()
//        // Add your subclass-specific initialization here.
//        accidentalPopUp!.addItemWithTitle("Natural")
//        accidentalPopUp!.addItemWithTitle("b")
//        accidentalPopUp!.addItemWithTitle("#")
//        accidentalPopUp!.selectItemAtIndex(0)
//        
//        rootPopUp!.addItemWithTitle("A")
//        rootPopUp!.addItemWithTitle("B")
//        rootPopUp!.addItemWithTitle("C")
//        rootPopUp!.addItemWithTitle("D")
//        rootPopUp!.addItemWithTitle("E")
//        rootPopUp!.addItemWithTitle("F")
//        rootPopUp!.addItemWithTitle("G")
//        rootPopUp!.selectItemAtIndex(4)
//        
//        addScaleNamesToPopUp()
//        updateFretboardModelAndViews()
    }

    
    
    //##########################################################
    override class func autosavesInPlace() -> Bool {
        return true
    }

    //##########################################################
    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    //##########################################################
    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    //##########################################################
    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

//    //##########################################################
//    // My Functions for fretboardView and Model updates. 
//    //##########################################################
//    func addScaleNamesToPopUp(){
//        for index in 0...(fretboardModel.allScales.scaleArray.count - 1){
//            scalePopUp!.addItemWithTitle(fretboardModel.allScales.scaleArray[index].scaleName)
//        }
//    }
//    
//    // update fretboardModel
//    func updateFretboardModelAndViews() {
//        fretboardModel.updateWithValues(rootPopUp!.titleOfSelectedItem!,
//                                        accidental: accidentalPopUp!.titleOfSelectedItem!,
//                                        scaleName: scalePopUp!.titleOfSelectedItem!)
//        fretboardView!.updateNoteModelArray(fretboardModel.fullFretboardArray!)
//        fretboardView.needsDisplay = true
//    }
//
}

