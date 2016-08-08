//
//  MainWindowController.swift
//  StringNotesCalculator
//
//  Copyright © 2016 Gire. All rights reserved.
/*  This Window controller builds fretboards on the FretboardView class
    via the FretboardCalculator class and the customize options. 
    Note: save capabilities have not yet been implemented    */

import Cocoa

class MainWindowController: NSWindowController, NSTableViewDataSource , NSTableViewDelegate{
    
    //##########################################################
    // Class Variables (except the outlets)
    //##########################################################
    
    // Offsets for toneNumber for each open string in standard tuning.
    let offsets = [0, 5, 10, 15, 19, 24]
    
    // Calculates 46 tone arrays.
    let zeroTo46ToneCalculator = ZeroTo46ToneCalculator()
    
    let NOTES_PER_STRING = 23
    
    private var fretboardModelArray: [FretboardModel] = [FretboardModel()]
    
    private var modelIndex = 0
    
    private var sourceIndex = 0
    //##########################################################
    // Outlets to fretboard controls.
    //##########################################################
    
    // Outlet to Controls window.
    @IBOutlet weak var controlsWindow: NSWindow!
    
    // Calculator controls.
    @IBOutlet weak var rootPopUp: NSPopUpButton!
    @IBOutlet weak var accidentalPopUp: NSPopUpButton!
    @IBOutlet weak var scalePopUp: NSPopUpButton!
    @IBOutlet weak var buildAndAddFretboardButton: NSButton!
    
    @IBOutlet weak var fretboardView: FretboardView!
    @IBOutlet weak var lockButton: NSButton!
    
    // Fretboard title outlets.
    @IBOutlet weak var enterTitle: NSTextField!
    @IBOutlet weak var displayTitle: NSTextField!
    
    // Customization controls.
    @IBOutlet weak var showControlsButton: NSButton!
    @IBOutlet weak var showCalcNotesButton: NSButton!
    @IBOutlet weak var selectCalcNotesButton: NSButton!
    @IBOutlet weak var showAdditionalNotesButton: NSButton!
    @IBOutlet weak var selectAdditionalNotesButton: NSButton!
   
    @IBOutlet weak var displayModePopUp: NSPopUpButton!

    
    @IBOutlet weak var clearUnselected: NSButton!
    @IBOutlet weak var unSelectAllButton: NSButton!
    @IBOutlet weak var customColorWell: NSColorWell!
    
    @IBOutlet weak var customizeView: NSView!
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var addFretboard: NSButton!
    
    
    //##########################################################
    // MARK: - Getters and Setters.
    //##########################################################
    
    func getFretboardModelArray()-> [FretboardModel] {
        return fretboardModelArray
    }
    func setFretboardModelArray(newArray: [FretboardModel]) {
        fretboardModelArray = newArray
    }
    
    //##########################################################
    // MARK: - Action functions.
    //##########################################################
    
    @IBAction func buildAndAddFretboard(sender: NSButton) {
        markSelectedNotesAsKept(true)
        updateZeroTo46ToneCalculator()
        updatefretboardModel()
    }

    // Show/Hide more editing options.
    @IBAction func showControlsWindow(sender: NSButton){
        // If the window isn't visible, launch window.
        if controlsWindow!.visible == false {
        let controlsWindowController = NSWindowController(window: controlsWindow!)
            
            controlsWindowController.showWindow(nil)
        }
    }

    
    // Shows/Hide Calculated notes.
    @IBAction func showCalculatedNotes(sender: NSButton) {
        // If the button is checked.
        if sender.state != 0 {
            
            // Show calculated notes as ghosted.
            showNotesOnFretboard(true, _isDisplayed: true, _isGhosted: true)
            selectCalcNotesButton!.enabled = true
        }
            // Hide calculated notes.
        else {
            showNotesOnFretboard(true, _isDisplayed: false, _isGhosted: true)
            selectCalcNotesButton!.enabled = false
            selectCalcNotesButton.state = 0
        }
    }
    
    
    
    @IBAction func selectCalcNotes(sender: NSButton){
        // If the button is checked, select notes.
        if sender.state != 0 {
            markSelectedNotesAsKept(false)
            showNotesOnFretboard(true, _isDisplayed: true, _isGhosted: false)
        }
        
            // if the button is unchecked, change to ghosted.
        else {
            // Keep any selected notes, then select.
            showNotesOnFretboard(true, _isDisplayed: true, _isGhosted: true)
        }
    }
    
    
    
    
    // Shows additional notes.
    @IBAction func showAdditionalNotes(sender: NSButton) {
        // If the button is checked.
        if sender.state != 0 {
            // Show chromatic notes.
            showNotesOnFretboard(false, _isDisplayed: true, _isGhosted: true)
            selectAdditionalNotesButton!.enabled = true
        }
           // Hide chromatic notes that aren't in the scale.
        else {
            showNotesOnFretboard(false, _isDisplayed: false, _isGhosted: true)
            selectAdditionalNotesButton!.enabled = false
            selectAdditionalNotesButton.state = 0
        }
    }
    
    
    // Selects addition notes.
    @IBAction func selectAdditionalNotes(sender: NSButton) {
        if sender.state != 0 {
            showNotesOnFretboard(false, _isDisplayed: true, _isGhosted: false)
        }
        else {
            showNotesOnFretboard(false, _isDisplayed: true, _isGhosted: true)
        }
    }
    
    // Clear unselected
    @IBAction func clearUnselected(sender: NSButton) {
        markSelectedNotesAsKept(true)
        
        showCalcNotesButton.state = 0
        showCalculatedNotes(showAdditionalNotesButton)
        
        showAdditionalNotesButton.state = 0
        showCalculatedNotes(showAdditionalNotesButton)
        
        showNotesOnFretboard(true, _isDisplayed: false, _isGhosted: true)
        showNotesOnFretboard(false, _isDisplayed: false, _isGhosted: true)
    }
    
    // Unselect all.
    @IBAction func unselectAll(sender: NSButton) {
        markSelectedNotesAsKept(false)
        showCalcNotesButton.state = 1
        selectCalcNotesButton.state = 0
        selectAdditionalNotesButton.state = 0
        
        showNotesOnFretboard(true, _isDisplayed: true, _isGhosted: true)
    }
    
    
    @IBAction func changeUserColor(sender: NSColorWell) {
        fretboardModelArray[modelIndex].setUserColor(sender.color)
        // Closes the color panel.
    }
    
    @IBAction func changeTitle(sender: NSTextField) {
        displayTitle.stringValue = sender.stringValue
        fretboardModelArray[modelIndex].setFretboardTitle(sender.stringValue)
        tableView!.reloadData()
    }
    
    @IBAction func lockFretboard(sender: NSButton) {
        let controller = NSWindowController(window: controlsWindow!)
        // If the lock button is checked,
        if sender.state != 0 {
            // Hide the controls window and disable the show controls button.
            showControlsButton.enabled = false
            controller.close()
            
            }
        // Else, the button isn't locked,
        else {
            showControlsButton.enabled = true
            controller.showWindow(nil)
        }
        // Update Model.
        fretboardModelArray[modelIndex].setIsLocked(sender.state)
    }
    
    @IBAction func updateDisplayMode(sender: NSPopUpButton) {
        // Go through the fretboard array and change the dipslaymode to whatever is selected. 
        for index in 0...137 {
            fretboardModelArray[modelIndex].getFretboardArray()[index].setDisplayMode(sender.titleOfSelectedItem!)
        }
        updateFretboardView()
    }
    
    @IBAction func addFretboard(sender: NSButton) {
        fretboardModelArray.append(FretboardModel())
        tableView!.reloadData()
    }
    
    @IBAction func setTitle(sender: NSTextField) {
        fretboardModelArray[modelIndex].setFretboardTitle(sender.stringValue)
        tableView!.reloadData()
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
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(MainWindowController.reactToMouseUpEvent(_:)),
                                                         name: "noteViewMouseUpEvent",
                                                         object: nil)
                
        //Update data from fretboardModelArray[modelIndex].
        enterTitle!.stringValue = fretboardModelArray[modelIndex].getFretboardTitle()
        displayTitle!.stringValue = fretboardModelArray[modelIndex].getFretboardTitle()
        lockButton.state = fretboardModelArray[modelIndex].getIsLocked()
        lockFretboard(lockButton)
        updateFretboardView()
        
        tableView.registerForDraggedTypes([NSPasteboardTypeString])
        
        
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
                                        /*displayMode: displayModePopUp!.titleOfSelectedItem!, */
                                        myCalcColor: NSColor.yellowColor())
                                        //selectNotes: selectionModePopUp.titleOfSelectedItem!)
        fillSpacesWithChromatic()

    }
    
    func updatefretboardModel() {
        
        // Update the NoteModel array on the fretboardController.
        updateToneArrayIntofretboardModel(zeroTo46ToneCalculator.getZeroTo46ToneArray())
        
        
        showCalcNotesButton.state = 1
        showCalculatedNotes(showCalcNotesButton)

        if selectCalcNotesButton.state == 0 {
            selectCalcNotes(selectCalcNotesButton)
            
        }
      
        
        // If auto selecting additional notes is not enabled during fretboardModelArray[modelIndex]Upate, reset controls.
        if selectAdditionalNotesButton.state == 0 {
            showAdditionalNotesButton.state = 0
          //  showAdditionalNotes(showAdditionalNotesButton)
        }
        

        // update the fretboardView.
        updateFretboardView()

    }
    
    func updateFretboardView() {
        fretboardView.updateSubviews(fretboardModelArray[modelIndex].getFretboardArray())
    }
    
    
    func fillSpacesWithChromatic()
    {
        let chromatic = ZeroTo46ToneCalculator()
        chromatic.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                   myAccidental: accidentalPopUp!.titleOfSelectedItem!,
                                   scaleName: "Chromatic Scale",
                                 /*  displayMode: displayModePopUp!.titleOfSelectedItem!, */
                                   myCalcColor: NSColor.redColor())
                                   //selectNotes: "")
        for index in 0...46 {
            let noteModel = zeroTo46ToneCalculator.getZeroTo46ToneArray()[index]
            let chromModel = chromatic.getZeroTo46ToneArray()[index]
                if noteModel.getNote() == "" {
                    noteModel.setNoteModel(chromModel)
                    noteModel.setIsInScale(false)
                    noteModel.setIsDisplayed(false)
                    noteModel.setIsKept(false)
                }
            
        }
    }
    // Shows notes on the fretboard.
    func showNotesOnFretboard( _isInScale: Bool, _isDisplayed: Bool, _isGhosted: Bool) {
        for index in 0...137 {
            let noteModel = fretboardModelArray[modelIndex].getFretboardArray()[index]
            
            // only edits the specified note: in the scale or not in the scale.
            if noteModel.getIsKept() != true {
                if noteModel.getIsInScale() == _isInScale {
                    noteModel.setIsDisplayed(_isDisplayed)
                    noteModel.setIsGhost(_isGhosted)
                    if _isInScale == true {
                        noteModel.setMyColor(fretboardModelArray[modelIndex].getUserColor())
                    }
                }
            }
        }
        updateFretboardView()
    }
    
    func reactToMouseUpEvent(notification: NSNotification) {
        // If fretboard isn't locked.
        if fretboardModelArray[modelIndex].getIsLocked() == 0 {
            // store the view number.
            let index = (notification.userInfo!["number"] as! Int)
            let noteModel = fretboardModelArray[modelIndex].getFretboardArray()[index]
        
            // if myColor hasn't been updated to the new userColor, redraw.
            if noteModel.getMyColor() != fretboardModelArray[modelIndex].getUserColor() {
                
                // Set the color correctly.
                noteModel.setMyColor(fretboardModelArray[modelIndex].getUserColor())
                
                // and if it isn't ghosted, just changed the color, don't ghost.
                if noteModel.getIsGhost() == true {
                    
                    noteModel.setIsGhost(!noteModel.getIsGhost())
                    noteModel.setIsKept(!noteModel.getIsKept())
                }
            }
                // Else, the colors are the same, turn unselected notes into selected notes, and vice versa.
            else {
                noteModel.setIsGhost(!noteModel.getIsGhost())
                noteModel.setIsKept(!noteModel.getIsKept())
            }
            // Close the color panel if still open.
            NSColorPanel.sharedColorPanel().close()
            // redraw.
            (notification.object as! NoteView).needsDisplay = true
        }
    }
    
    func markSelectedNotesAsKept(doKeep: Bool) {
        for index in 0...137 {
            let model = fretboardModelArray[modelIndex].getFretboardArray()[index]
            
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
    }
    
    func updateToneArrayIntofretboardModel(toneArray: [NoteModel]) {
        for stringIndex in 0...5 {
            for noteIndex in 0...(NOTES_PER_STRING - 1){
                let noteModel = (fretboardModelArray[modelIndex].getFretboardArray()[noteIndex + (stringIndex * NOTES_PER_STRING)])
                let zeroTo46Model = toneArray[noteIndex + offsets[stringIndex]]
                
                // For all noteModels not marked as kept, set the noteModel to the zeroTo46 Model.
                if noteModel.getIsKept() == false {
                    noteModel.setNoteModel(zeroTo46Model)
                }
            }
        }
    }
    
    func setItemImage() {
        let view = window?.contentView
        let data = view!.dataWithPDFInsideRect(view!.bounds)
        let image = NSImage(data: data)
        fretboardModelArray[modelIndex].setItemImage(image!)
    }
    
    func reArrangeModelArray(source: Int, destination: Int) {
        
        
        let model = fretboardModelArray[source]
        fretboardModelArray.insert(model, atIndex: destination)
        
        if  destination > source {
            fretboardModelArray.removeAtIndex(source)
        }
        else{
            fretboardModelArray.removeAtIndex(source + 1)
        }
        
        
    }
    

    //##########################################################
    // TableViewDataSource functions.
    //##########################################################
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return fretboardModelArray.count
    }
    
    func tableView(tableView: NSTableView,
                   objectValueForTableColumn tableColumn: NSTableColumn?,
                                             row: Int) -> AnyObject? {
        return fretboardModelArray[row].getFretboardTitle()
    }
    
    // Writes the selected row to the pasteboard.
    func tableView(tableView: NSTableView,
                   writeRowsWithIndexes rowIndexes: NSIndexSet,
                                        toPasteboard pboard: NSPasteboard) -> Bool {
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(rowIndexes)
        
        pboard.declareTypes([NSPasteboardTypeString], owner: self)
        pboard.setData(data, forType:  "rowData")
        sourceIndex = rowIndexes.firstIndex
        return true
    }
    
    
    
    
    //What kind of drag and drop operation should I perform
    func tableView(tableView: NSTableView,
                   validateDrop info: NSDraggingInfo,
                                proposedRow row: Int,
                                            proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        
        if (dropOperation == .Above) {
            return .Move
        }
        return .None
    }
    
    
    // Allow Drop
    func tableView(tableView: NSTableView,
                     acceptDrop info: NSDraggingInfo,
                                row: Int,
                                dropOperation: NSTableViewDropOperation) -> Bool {
        
        
        reArrangeModelArray(sourceIndex, destination: row)
        tableView.reloadData()

        return true
    }
    
    // Setting Values
    
    
//        func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
//        let string = (object as! NSTextFieldCell).stringValue
//            fretboardModelArray[row].setFretboardTitle(string)
//    }
    
    
    //##########################################################
    // TableViewDelegate.
    //##########################################################

    // Row Selection.
    func tableViewSelectionDidChange(notification: NSNotification) {
      // Update the view to display the selected fretboard.
        modelIndex = tableView.selectedRow
        updateFretboardView()
        
    }
    
   
    
}



