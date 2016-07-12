//
//  MainWindowController.swift
//  StringNotesCalculator
//
//  Created by Ben Gire on 4/22/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    //##########################################################
    // Outlets to fretboard controls.
    //##########################################################
    @IBOutlet weak var rootPopUp: NSPopUpButton!
    @IBOutlet weak var accidentalPopUp: NSPopUpButton!
    @IBOutlet weak var scalePopUp: NSPopUpButton!
    @IBOutlet weak var displayModePopUp: NSPopUpButton!
    @IBOutlet weak var fretboardView: FretboardView!
    @IBOutlet weak var customizeButton: NSButton!
    
    //##########################################################
    // variables to hold outlets previous values.
    //##########################################################
    var previousRoot = ""
    var previousAccidental = ""
    var previousScale = ""
    var previousDisplay = ""
    

    //##########################################################
    // Actions.
    //##########################################################
    // Root update
    @IBAction func updateRoot(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousRoot {
            updateFretboardControllerAndViews()
            previousRoot = sender.titleOfSelectedItem!
        }
    }
    // Accidental update
    @IBAction func updateAccidental(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousAccidental {
            updateFretboardControllerAndViews()
            previousAccidental = sender.titleOfSelectedItem!
        }
    }
    // Scale updtae.
    @IBAction func updateScale(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousScale {
            updateFretboardControllerAndViews()
            previousScale = sender.titleOfSelectedItem!
        }
    }
    // Display update.
    @IBAction func updateFretDisplay(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousDisplay {
            fretboardView!.displayMode = sender.titleOfSelectedItem!
            fretboardView!.updateSubviews()
            previousDisplay = sender.titleOfSelectedItem!
        }
    }
    
    @IBAction func enableCustomizing(sender: NSButton){
        if sender.state != 0 {
            fretboardView.canCustomise = true
        }
        else {
            fretboardView.canCustomise = false
        }
        fretboardView.updateSubviews()
    }
    
    //##########################################################
    // Class Variables (except the outlets previous values holders.
    //##########################################################

    var fretboardController = FretboardController()
    
    //##########################################################
    // Window Controller overriden functions.
    //##########################################################
    
    override var windowNibName: String? {
        return "MainWindowController"
    }
    
    // Handles any initialization after the window controller's window has been loaded from its nib file.
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Build PopUps.
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
        scalePopUp!.selectItemAtIndex(scalePopUp!.indexOfItemWithTitle("Minor Pentatonic Scale"))
        
        displayModePopUp!.addItemWithTitle("Notes")
        displayModePopUp!.addItemWithTitle("Intervals")
        displayModePopUp!.addItemWithTitle("Numbers 0-11")
        displayModePopUp!.addItemWithTitle("Numbers 0-46")
        displayModePopUp!.selectItemAtIndex(0)
        
        
        // Set previousValues to default values.
        previousRoot = rootPopUp!.titleOfSelectedItem!
        previousAccidental = accidentalPopUp!.titleOfSelectedItem!
        previousScale = scalePopUp!.titleOfSelectedItem!
        previousDisplay = displayModePopUp!.titleOfSelectedItem!
    
        updateFretboardControllerAndViews()
    }
    
    //##########################################################
    // Custom class functions.
    //##########################################################
    // Adds the scale names to the Scale PopUp
    func addScaleNamesToPopUp(){
        for index in 0...(AllScales().scaleArray.count - 1){
            scalePopUp!.addItemWithTitle(AllScales().scaleArray[index].scaleName)   
        }
        // Adds separator items to make the scales popUp easier to read.
        scalePopUp!.menu?.insertItem(NSMenuItem.separatorItem(), atIndex: 14)
        scalePopUp!.menu?.insertItem(NSMenuItem.separatorItem(), atIndex: 22)
        scalePopUp!.menu?.insertItem(NSMenuItem.separatorItem(), atIndex: 31)
    }
    
    // Updates the FretboardController and subviews.
    func updateFretboardControllerAndViews() {
        // Update Model with current values.
        fretboardController.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                        accidental: accidentalPopUp!.titleOfSelectedItem!,
                                        scaleName: scalePopUp!.titleOfSelectedItem!)
        // Update Display Mode.
        fretboardView.displayMode = displayModePopUp!.titleOfSelectedItem!
        // Update the NoteModel array on the FretboardView.
        fretboardView!.updateNoteModelArray(fretboardController.array)
        // Display the changes.
        fretboardView.needsDisplay = true
    }
    
}

