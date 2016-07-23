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
    // Class Variables (except the outlets)
    //##########################################################
    
    let offsets = [0, 5, 10, 15, 19, 24]
    
    let zeroTo46ToneCalculator = ZeroTo46ToneCalculator()
    
    let NOTES_PER_STRING = 23
    
    let fretboardModel = FretboardModel()
    
    private var userColor = NSColor.yellowColor()

    private var canCustomize = false
    
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
            updateZeroTo46ToneCalculator()
            updateFretboardModel()
            previousRoot = sender.titleOfSelectedItem!
        }
    }
    // Accidental update
    @IBAction func updateAccidental(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousAccidental {
            updateZeroTo46ToneCalculator()
            updateFretboardModel()
            previousAccidental = sender.titleOfSelectedItem!
        }
    }
    // Scale update.
    @IBAction func updateScale(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousScale {
            updateZeroTo46ToneCalculator()
            updateFretboardModel()
            previousScale = sender.titleOfSelectedItem!
        }
    }
    // Display update.
    @IBAction func updateFretDisplay(sender: NSPopUpButton) {
        if sender.titleOfSelectedItem! != previousDisplay {
            updateZeroTo46ToneCalculator()
            updateFretboardModel()
            
            
            // I'll need to update the calculator first.
            //fretboardView!.updateSubviews()
            previousDisplay = sender.titleOfSelectedItem!
        }
    }
    
    // Enable Customizing
    @IBAction func enableCustomizing(sender: NSButton){
        if sender.state != 0 {
            
            // sets noteViews canCustomizeProperty to true.
             canCustomize = true
            
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
             canCustomize = false
            
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
            markSelectedNotesAsKept(true)
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
            markSelectedNotesAsKept(true)
            showNotesFromCalcedFretArray(false, _isDisplayed: true, _isGhosted: false)
        }
        else {
            showNotesFromCalcedFretArray(false, _isDisplayed: true, _isGhosted: true)
        }
    }
    
    @IBAction func unselectAll(sender: NSButton) {
        markSelectedNotesAsKept(false)
        selectCalcNotesButton.state = 0
        selectAdditionalNotesButton.state = 0
    }
    
    @IBAction func keepSelectedNotes(sender: NSButton) {
         markSelectedNotesAsKept(true)
    }
    
    @IBAction func changeUserColor(sender: NSColorWell) {
        setUserColor(sender.color)
        // Closes the color panel. 
        NSColorPanel.sharedColorPanel().close()
    }
    
    @IBAction func changeTitle(sender: NSTextField) {
        displayTitle.stringValue = sender.stringValue
    }
    

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
    
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(MainWindowController.reactToMouseUpEvent(_:)),
                                                         name: "noteViewMouseUpEvent",
                                                         object: nil)
        
        updateZeroTo46ToneCalculator()
        updateFretboardModel()
        
        

        
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
    func updateZeroTo46ToneCalculator() {
        // Update Model with current values.
        zeroTo46ToneCalculator.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                        myAccidental: accidentalPopUp!.titleOfSelectedItem!,
                                        scaleName: scalePopUp!.titleOfSelectedItem!,
                                        displayMode: displayModePopUp!.titleOfSelectedItem!)
        fillSpacesWithChromatic()
        
        // If customizing, new scales set to ghost mode. 
        if customizeButton.state != 0 {
            // GhostNotes.
            markSelectedNotesAsKept(true)
            showNotesFromCalcedFretArray(true, _isDisplayed: true, _isGhosted: true)
        }
       
    }
    
    func updateFretboardModel() {
        // Update Display Mode.
        // fretboardController.setDisplayMode(displayModePopUp!.titleOfSelectedItem!)
        
        // Update the NoteModel array on the  fretboardController.
        updateToneArrayIntoFretboardModel(zeroTo46ToneCalculator.getZeroTo46ToneArray())
        
        fretboardView.updateSubviews(fretboardModel.array)
        // Display the changes.
        //fretboardView.needsDisplay = true
    }
    
    
    func fillSpacesWithChromatic()
    {
        let chromatic = ZeroTo46ToneCalculator()
        chromatic.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                   myAccidental: accidentalPopUp!.titleOfSelectedItem!,
                                   scaleName: "Chromatic Scale",
                                   displayMode: displayModePopUp!.titleOfSelectedItem!)
        for index in 0...46 {
            let noteModel = zeroTo46ToneCalculator.getZeroTo46ToneArray()[index]
            let chromModel = chromatic.getZeroTo46ToneArray()[index]
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
            let noteModel = zeroTo46ToneCalculator.getZeroTo46ToneArray()[index]
            if noteModel.getIsInScale() == _isInScale {
                noteModel.setIsDisplayed(_isDisplayed)
                noteModel.setIsGhost(_isGhosted)
            }
        }
        updateFretboardModel()
    }
    
    func reactToMouseUpEvent(notification: NSNotification) {
        if canCustomize {
            // store the view number.
            let index = (notification.userInfo!["number"] as! Int)
            let noteModel = fretboardModel.array[index]
            // if myColor hasn't been updated to the new userColor, redraw.
            if noteModel.getMyColor() != userColor {
                
                // Set the color correctly.
                noteModel.setMyColor(userColor)
                
                // and if it isn't ghosted, just changed the color, don't ghost.
                if noteModel.getIsGhost() == true {
                    
                    noteModel.setIsGhost(!noteModel.getIsGhost())
                }
            }
                // Else, the colors are the same, turn unselected notes into selected notes, and vice versa.
            else {
                noteModel.setIsGhost(!noteModel.getIsGhost())
            }
            
            // redraw.
            (notification.object as! NoteView).needsDisplay = true
        }
    }
    
    // Sets the color for Calculated Notes.
    func setUserColor(newColor: NSColor){
        userColor = newColor
    }
    
    //    func updateZeroTo46ToneArray(newArray: [NoteModel]) {
    //        zeroTo46ToneArray = newArray
    //    }
    
    
    func markSelectedNotesAsKept(doKeep: Bool) {
        for index in 0...137 {
            let model = fretboardModel.array[index]
            
            // If the view is displayed, determine whether to keep.
            if model.getIsDisplayed() == true {
                // If ghosted, don't keep
                if model.getIsGhost() == true {
                    model.setIsKept(false)
                }
                    // If unghosted, keep or unkeep depending on the value of 'doKeppt
                else {
                    model.setIsKept(doKeep)
                    // If we've unSelected the note via unselectAll
                    // update the ghost value and display with current value.
                    if doKeep == false {
                        model.setIsGhost(true)
                    }
                }
            }
        }
        
        //needsDisplay = true
    }
    
    func updateToneArrayIntoFretboardModel(toneArray: [NoteModel]) {
        for stringIndex in 0...5 {
            for noteIndex in 0...(NOTES_PER_STRING - 1){
                let noteModel = (fretboardModel.array[noteIndex + (stringIndex * NOTES_PER_STRING)])
                let zeroTo46Model = toneArray[noteIndex + offsets[stringIndex]]
                
                // For all noteModels not marked as kept, set the noteModel to the zeroTo46 Model.
                if noteModel.getIsKept() == false {
                    noteModel.setNoteModel(zeroTo46Model)
                }
            }
        }
    }
}



