//
//  MainWindowController.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 4/22/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    // Outlets to scale controls.
    @IBOutlet weak var accidentalPopUp: NSPopUpButton!
    @IBOutlet weak var rootPopUp: NSPopUpButton!
    @IBOutlet weak var scalePopUp: NSPopUpButton!
    
//    @IBOutlet weak var notesAndIntervals: NSTextField!
    
    
    // Outlet to fretboardView.
    @IBOutlet weak var fretboardView: FretboardView!
    
    @IBAction func updateRoot(sender: NSPopUpButton) {
        updateFretboardModelAndViews()
    }
    
    @IBAction func updateAccidental(sender: NSPopUpButton) {
        updateFretboardModelAndViews()
    }
    
    @IBAction func updateScale(sender: NSPopUpButton) {
        updateFretboardModelAndViews()
    }
    
    
    // FretboardModel to update Strings.
    var fretboardModel = FretboardModel()
    
    
    override var windowNibName: String? {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        accidentalPopUp!.addItemWithTitle("Natural")
        accidentalPopUp!.addItemWithTitle("b")
        accidentalPopUp!.addItemWithTitle("#")
        accidentalPopUp!.selectItemAtIndex(0)
        
        rootPopUp!.addItemWithTitle("A")
        rootPopUp!.addItemWithTitle("B")
        rootPopUp!.addItemWithTitle("C")
        rootPopUp!.addItemWithTitle("D")
        rootPopUp!.addItemWithTitle("E")
        rootPopUp!.addItemWithTitle("F")
        rootPopUp!.addItemWithTitle("G")
        rootPopUp!.selectItemAtIndex(4)
        
        addScaleNamesToPopUp()
        updateFretboardModelAndViews()
    }
    
    
    func addScaleNamesToPopUp(){
        for index in 0...(fretboardModel.allScales.scaleArray.count - 1){
            scalePopUp!.addItemWithTitle(fretboardModel.allScales.scaleArray[index].scaleName)
        }
    }
    
    // update fretboardModel
    func updateFretboardModelAndViews() {
        fretboardModel.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                        accidental: accidentalPopUp!.titleOfSelectedItem!,
                                        scaleName: scalePopUp!.titleOfSelectedItem!)
        fretboardView!.updateNoteModelArray(fretboardModel.fullFretboardArray!)
        fretboardView.needsDisplay = true
    }
    
}

