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
    @IBOutlet weak var ghostCalcNotesButton: NSButton!
    @IBOutlet weak var addMoreNotesButton: NSButton!
    @IBOutlet weak var unghostAddMoreNotesButton: NSButton!
    
    @IBOutlet weak var markSelectedAsKeptButton: NSButton!
    
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
            
            // Displays ghosting buttons
            fretboardView.updateCanCustomize(true)
            ghostCalcNotesButton!.hidden = false
            ghostCalcNotes(ghostCalcNotesButton)
            addMoreNotesButton!.hidden = false
            unghostAddMoreNotesButton!.hidden = false
            updateFretboardView()
            
            // Disables formula editor. 
            
        }
        else {
            fretboardView.updateCanCustomize(false)
            ghostCalcNotesButton!.hidden = true
            addMoreNotesButton!.hidden = true
            unghostAddMoreNotesButton!.hidden = true
        }
    }

    // Enable Ghosting
    @IBAction func ghostCalcNotes(sender: NSButton){
        if sender.state != 0 {
            
            showNotesFromFretArray(true, _isDisplayed: true, _isGhosted: true)
            updateFretboardView()
        }
            // Hide chromatic notes that aren't in the scale.
        else {
            showNotesFromFretArray(true, _isDisplayed: true, _isGhosted: false)
            updateFretboardView()
        }
        //fretboardView.updateSubviews()
    }
    
    @IBAction func addMoreNotes(sender: NSButton) {
        
        if sender.state != 0 {
            // Show chromatic notes.
            showNotesFromFretArray(false, _isDisplayed: true, _isGhosted: true)
            unghostAddMoreNotesButton!.enabled = true
            updateFretboardView()
        }
           // Hide chromatic notes that aren't in the scale.
        else {
            showNotesFromFretArray(false, _isDisplayed: false, _isGhosted: true)
            unghostAddMoreNotesButton!.enabled = false
            unghostAddMoreNotesButton.state = 0
            updateFretboardView()
        }
    }
    
    @IBAction func unghostAddMoreNotes(sender: NSButton) {
        if sender.state != 0 {
            showNotesFromFretArray(false, _isDisplayed: true, _isGhosted: false)
            updateFretboardView()
        }
        else {
            showNotesFromFretArray(false, _isDisplayed: true, _isGhosted: true)
            updateFretboardView()
        }
    }
    
    @IBAction func markSelectedAsKept(sender: NSButton) {
        if sender.state != 0 {
            
        }
    }
    
    //##########################################################
    // Class Variables (except the outlets previous values holders.
    //##########################################################

    var fretboardCalculator = FretboardCalculator()
    
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
            
                if fretboardCalculator.fretArray[index].note == "" {
                    fretboardCalculator.fretArray[index].note = chromatic.fretArray[index].note
                    fretboardCalculator.fretArray[index].interval = chromatic.fretArray[index].interval
                    fretboardCalculator.fretArray[index].number0to11 = chromatic.fretArray[index].number0to11
                    fretboardCalculator.fretArray[index].number0to46 = chromatic.fretArray[index].number0to46
                }
            
        }
    }
    func showNotesFromFretArray( _isInScale: Bool, _isDisplayed: Bool, _isGhosted: Bool) {
        for index in 0...46 {
            if fretboardCalculator.fretArray[index].isInscale == _isInScale {
                fretboardCalculator.fretArray[index].isDisplayed = _isDisplayed
                fretboardCalculator.fretArray[index].isGhost = _isGhosted
            }
        }
    }
}

