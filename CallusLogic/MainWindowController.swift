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
    @IBOutlet weak var selectCalcNotesButton: NSButton!
    @IBOutlet weak var showAdditionalNotesButton: NSButton!
    @IBOutlet weak var selectAdditionalNotesButton: NSButton!
    
    @IBOutlet weak var unSelectAllButton: NSButton!
    
    
    @IBOutlet weak var customizeControlsView: NSView!
    
    //##########################################################
    // variables to hold outlets previous values.
    //##########################################################
    var previousRoot = ""
    var previousAccidental = ""
    var previousScale = ""
    var previousDisplay = ""
    
    var chromaticsWereAdded = false
    //##########################################################
    // Actions.
    //##########################################################
    // Root update
    @IBAction func updateRoot(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousRoot {
            updateFretboardCalculator()
            updateFretboardView()
            previousRoot = sender.titleOfSelectedItem!
        }
    }
    // Accidental update
    @IBAction func updateAccidental(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousAccidental {
            updateFretboardCalculator()
            updateFretboardView()
            previousAccidental = sender.titleOfSelectedItem!
        }
    }
    // Scale updtae.
    @IBAction func updateScale(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousScale {
            updateFretboardCalculator()
            updateFretboardView()
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
    
    // Enable Customizing
    @IBAction func enableCustomizing(sender: NSButton){
        if sender.state != 0 {
            
            // sets noteViews canCustomizeProperty to true.
            fretboardView.updateCanCustomize(true)
            
            // Unhide customize controls.
            customizeControlsView.hidden = false
            
            // Set the selectCalcNotesButton to on.
            selectCalcNotesButton.state = 0
            selectCalcNotes(selectCalcNotesButton)
            
            // Set the addMoreNotesButton to off. 
            showAdditionalNotesButton.state = 0
            showAdditionalNotes(showAdditionalNotesButton)

            // Update Views
            updateFretboardView()
        }
        else {
            fretboardView.updateCanCustomize(false)
            customizeControlsView.hidden = true
        }
    }

    // Enable Ghosting
    @IBAction func selectCalcNotes(sender: NSButton){
        if sender.state == 0 {
            
            showNotesFromFretArray(true, _isDisplayed: true, _isGhosted: true)
            updateFretboardView()
        }
            // Hide chromatic notes that aren't in the scale.
        else {
            showNotesFromFretArray(true, _isDisplayed: true, _isGhosted: false)
            updateFretboardView()
        }
    }
    
    @IBAction func showAdditionalNotes(sender: NSButton) {
        
        if sender.state != 0 {
            // Show chromatic notes.
            fretboardView.markSelectedNotesAsKept(true)
            showNotesFromFretArray(false, _isDisplayed: true, _isGhosted: true)
            selectAdditionalNotesButton!.enabled = true
            updateFretboardView()
        }
           // Hide chromatic notes that aren't in the scale.
        else {
            showNotesFromFretArray(false, _isDisplayed: false, _isGhosted: true)
            selectAdditionalNotesButton!.enabled = false
            selectAdditionalNotesButton.state = 0
            updateFretboardView()
        }
    }
    
    @IBAction func selectAdditionalNotes(sender: NSButton) {
        if sender.state != 0 {
            showNotesFromFretArray(false, _isDisplayed: true, _isGhosted: false)
            updateFretboardView()
        }
        else {
            showNotesFromFretArray(false, _isDisplayed: true, _isGhosted: true)
            updateFretboardView()
        }
    }
    
    @IBAction func unselectAll(sender: NSButton) {


            fretboardView.markSelectedNotesAsKept(false)
            //updateFretboardView()
            
        
    }
    
    //##########################################################
    // Class Variables (except the outlets previous values holders.
    //##########################################################

    let fretboardCalculator = FretboardCalculator()
    
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
    
        updateFretboardCalculator()
        updateFretboardView()
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
    
    // Updates the FretboardCalculator and subviews.
    func updateFretboardCalculator() {
        // Update Model with current values.
        fretboardCalculator.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                        myAccidental: accidentalPopUp!.titleOfSelectedItem!,
                                        scaleName: scalePopUp!.titleOfSelectedItem!)
        fillSpacesWithChromatic()
        
        // If customizing, new scales set to ghost mode. 
        if customizeButton.state != 0 {
            // GhostNotes.
            fretboardView.markSelectedNotesAsKept(true)
            showNotesFromFretArray(true, _isDisplayed: true, _isGhosted: true)
        }
       
    }
    
    func updateFretboardView() {
        
        
        // Update Display Mode.
        fretboardView.displayMode = displayModePopUp!.titleOfSelectedItem!
        // Update the NoteModel array on the FretboardView.
        fretboardView!.updateNoteModelArray(fretboardCalculator.fretArray)
        
        
        
        // Display the changes.
        fretboardView.needsDisplay = true
    }
    
    
    func fillSpacesWithChromatic()
    {
        let chromatic = FretboardCalculator()
        chromatic.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                   myAccidental: accidentalPopUp!.titleOfSelectedItem!,
                                   scaleName: "Chromatic Scale")
        for index in 0...46 {
            let fret = fretboardCalculator.fretArray[index]
            
                if fret.note == "" {
                    fret.note = chromatic.fretArray[index].note
                    fret.interval = chromatic.fretArray[index].interval
                    fret.number0to11 = chromatic.fretArray[index].number0to11
                    fret.number0to46 = chromatic.fretArray[index].number0to46
                }
            
        }
    }
    
    func showNotesFromFretArray( _isInScale: Bool, _isDisplayed: Bool, _isGhosted: Bool) {
        for index in 0...46 {
            let fret = fretboardCalculator.fretArray[index]
            if fret.isInscale == _isInScale {
                fret.isDisplayed = _isDisplayed
                fret.isGhost = _isGhosted
            }
        }
    }
}



