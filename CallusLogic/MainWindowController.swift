//
//  MainWindowController.swift
//  StringNotesCalculator
//
//  Copyright © 2016 Gire. All rights reserved.
/*  This Window controller builds fretboards on the FretboardView class
    via the FretboardCalculator class and the customize options. 
    Note: save capabilities have not yet been implemented    */

import Cocoa

class MainWindowController: NSWindowController {
    
    //##########################################################
    // Outlets to fretboard controls.
    //##########################################################
    
    // Calculator controls.
    @IBOutlet weak var rootPopUp: NSPopUpButton!
    @IBOutlet weak var accidentalPopUp: NSPopUpButton!
    @IBOutlet weak var scalePopUp: NSPopUpButton!
    @IBOutlet weak var displayModePopUp: NSPopUpButton!
    
    @IBOutlet weak var fretboardView: FretboardView!
    
    // Fretboard title outlets.
    @IBOutlet weak var enterTitle: NSTextField!
    @IBOutlet weak var displayTitle: NSTextField!
    
    // Customization controls.
    @IBOutlet weak var customizeButton: NSButton!
    @IBOutlet weak var selectCalcNotesButton: NSButton!
    @IBOutlet weak var showAdditionalNotesButton: NSButton!
    @IBOutlet weak var selectAdditionalNotesButton: NSButton!
    @IBOutlet weak var unSelectAllButton: NSButton!
    @IBOutlet weak var customColorWell: NSColorWell!
    
    @IBOutlet weak var customizeView: NSView!
    
    
    
    //##########################################################
    // variables to hold outlets previous values.
    //##########################################################
    private var previousRoot = ""
    private var previousAccidental = ""
    private var previousScale = ""
    private var previousDisplay = ""
    
    //private var chromaticsWereAdded = false
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
    // Scale update.
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
            fretboardView!.setDisplayMode(sender.titleOfSelectedItem!)
            fretboardView!.updateSubviews()
            previousDisplay = sender.titleOfSelectedItem!
        }
    }
    
    // RadioButton Action 
    

    
    // Enable Customizing
    @IBAction func enableCustomizing(sender: NSButton){
        if sender.state != 0 {
            
            // sets noteViews canCustomizeProperty to true.
            fretboardView.updateCanCustomize(true)
            
            customizeView.hidden = false
            
            // Set the selectCalcNotesButton to on.
            selectCalcNotesButton.state = 0
            selectCalcNotes(selectCalcNotesButton)
            
            // Set the addMoreNotesButton to off. 
            showAdditionalNotesButton.state = 0
            showAdditionalNotes(showAdditionalNotesButton)
        }
        else {
            // disable customization and hide radio buttons
            fretboardView.updateCanCustomize(false)
            
            customizeView.hidden = true
        }
    }

    // Enable Ghosting
    @IBAction func selectCalcNotes(sender: NSButton){
        // If the checkbox is unchecked, ghost the notes.
        if sender.state == 0 {
            showNotesFromCalcedFretArray(true, _isDisplayed: true, _isGhosted: true)
            
        }
        
            // If checked,
        else {
            // Keep any selected notes, then select.
           // fretboardView.markSelectedNotesAsKept(true)
            showNotesFromCalcedFretArray(true, _isDisplayed: true, _isGhosted: false)
        }
    }
    
    @IBAction func showAdditionalNotes(sender: NSButton) {
        
        if sender.state != 0 {
            // Show chromatic notes.
            fretboardView.markSelectedNotesAsKept(true)
            showNotesFromCalcedFretArray(false, _isDisplayed: true, _isGhosted: true)
            selectAdditionalNotesButton!.enabled = true
        }
           // Hide chromatic notes that aren't in the scale.
        else {
            showNotesFromCalcedFretArray(false, _isDisplayed: false, _isGhosted: true)
            selectAdditionalNotesButton!.enabled = false
            selectAdditionalNotesButton.state = 0
        }
    }
    
    @IBAction func selectAdditionalNotes(sender: NSButton) {
        if sender.state != 0 {
            fretboardView.markSelectedNotesAsKept(true)
            showNotesFromCalcedFretArray(false, _isDisplayed: true, _isGhosted: false)
        }
        else {
            showNotesFromCalcedFretArray(false, _isDisplayed: true, _isGhosted: true)
        }
    }
    
    @IBAction func unselectAll(sender: NSButton) {
        fretboardView.markSelectedNotesAsKept(false)
        selectCalcNotesButton.state = 0
        selectAdditionalNotesButton.state = 0
    }
    
    @IBAction func keepSelectedNotes(sender: NSButton) {
        fretboardView.markSelectedNotesAsKept(true)
    }
    
    @IBAction func changeNoteColor(sender: NSColorWell) {
        fretboardView.setMyColor(sender.color)
        // Closes the color panel. 
        NSColorPanel.sharedColorPanel().close()
    }
    
    @IBAction func changeTitle(sender: NSTextField) {
        displayTitle.stringValue = sender.stringValue
    }
    
    //##########################################################
    // Class Variables (except the outlets previous values holders.
    //##########################################################

    let fretboardCalculator = FretboardCalculator()
    
    //##########################################################
    // Window Controller overridden functions.
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
        for index in 0...(AllScales().getScaleArray().count - 1){
            scalePopUp!.addItemWithTitle(AllScales().getScaleArray()[index].getScaleName())
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
            showNotesFromCalcedFretArray(true, _isDisplayed: true, _isGhosted: true)
        }
       
    }
    
    func updateFretboardView() {
        // Update Display Mode.
        fretboardView.setDisplayMode(displayModePopUp!.titleOfSelectedItem!)
        // Update the NoteModel array on the FretboardView.
        fretboardView!.updateNoteModelArray(fretboardCalculator.getFretArray())
        
        
        
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
            let noteModel = fretboardCalculator.getFretArray()[index]
            let chromModel = chromatic.getFretArray()[index]
                if noteModel.getNote() == "" {
                    noteModel.setNote(chromModel.getNote()) //= chromatic.fretArray[index].note
                    noteModel.setInterval(chromModel.getInterval())
                    noteModel.setNumber0to11(chromModel.getNumber0to11()) // = chromatic.fretArray[index].number0to11
                    noteModel.setNumber0to46(chromModel.getNumber0to46())
                }
            
        }
    }
    
    func showNotesFromCalcedFretArray( _isInScale: Bool, _isDisplayed: Bool, _isGhosted: Bool) {
        for index in 0...46 {
            let noteModel = fretboardCalculator.getFretArray()[index]
            if noteModel.getIsInScale() == _isInScale {
                noteModel.setIsDisplayed(_isDisplayed)
                noteModel.setIsGhost(_isGhosted)
            }
        }
        updateFretboardView()
    }
}



