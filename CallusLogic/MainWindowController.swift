//
//  MainWindowController.swift
//  StringNotesCalculator
//
//  Copyright © 2016 Gire. All rights reserved.
/*  This Window controller builds fretboards on the FretboardView class
    via the FretboardCalculator class and the customize options. 
    Note: save capabilities have not yet been implemented    */

import Cocoa

class MainWindowController: NSWindowController, NSTableViewDataSource , NSTableViewDelegate, NSWindowDelegate{
    
    //##########################################################
    // Class Variables (except the outlets)
    //##########################################################
    
    // Offsets for toneNumber for each open string in standard tuning.
    let offsets = [0, 5, 10, 15, 19, 24]
    
    // Calculates 46 tone arrays.
    let zeroTo46ToneCalculator = ZeroTo46ToneCalculator()
    
    let NOTES_PER_STRING = 23
    
    private var fretboardModelArray: [FretboardModel] = [FretboardModel()]
    
    private var model = FretboardModel()
    
    private var modelIndex: Int = 0 {
        didSet{
            model = fretboardModelArray[modelIndex]
        }
    }
    
    
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
    @IBOutlet weak var displayTitle: NSTextField!
    
    // Customization controls.
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
    
    // Panels
    @IBOutlet weak var playlistPanel: NSPanel!
    
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
    
    @IBAction func addCalculatedFretboard(sender: NSButton) {
        markSelectedNotesAsKept(true)
        updateZeroTo46ToneCalculator()
        updatefretboardModel()
    }
    
    @IBAction func addFretboard(sender: NSButton) {
        addAFretboard()
    }
    
    func addAFretboard() {
        
        
        let undo = document?.undoManager!
        undo!.prepareWithInvocationTarget(self).removeLastFretboard()
        
        
        if !undo!.undoing{
            undo!.setActionName("undo AddFretboard")
        }
        
        fretboardModelArray.append(FretboardModel())
        tableView!.reloadData()
        let row = NSIndexSet(index: fretboardModelArray.count - 1)
        tableView.selectRowIndexes(row, byExtendingSelection: false)
    }
    
    
    
    
    func removeLastFretboard() {
        let undo = document!.undoManager!
        undo!.prepareWithInvocationTarget(self).addAFretboard()
        
        
        if !undo!.undoing{
            undo!.setActionName("remove last Fretboard")
        }

        
         fretboardModelArray.removeLast()
    }
    
    @IBAction func setTitle(sender: NSTextField) {
        model.setFretboardTitle(sender.stringValue)
        displayTitle.stringValue = sender.stringValue
    }
    
    // Shows/Hide Calculated notes.
    @IBAction func showCalcNotes(sender: NSButton) {
      
        model.setShowCalcedNotes(sender.state)
        
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
        model.setSelectCalcedNotes(sender.state)
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
        model.setShowAdditionalNotes(sender.state)
        
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
        model.setSelectAdditionalNotes(sender.state)
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
        showCalcNotes(showAdditionalNotesButton)
        
        showAdditionalNotesButton.state = 0
        showCalcNotes(showAdditionalNotesButton)
        
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
        model.setUserColor(sender.color)
        // Closes the color panel.
    }
    
    @IBAction func lockFretboard(sender: NSButton) {
        let controller = NSWindowController(window: controlsWindow!)
        // If the lock button is checked,
        if sender.state != 0 {
            // Hide the controls window and disable the show controls button.
            controller.close()
            
            }
        // Else, the button isn't locked,
        else {
            controller.showWindow(nil)
        }
        // Update Model.
        model.setIsLocked(sender.state)
    }
    
    @IBAction func updateDisplayMode(sender: NSPopUpButton) {
        
        model.setDisplayMode(sender.indexOfSelectedItem)
        // Go through the fretboard array and change the dipslaymode to whatever is selected.
        for index in 0...137 {
            model.getFretboardArray()[index].setDisplayMode(sender.titleOfSelectedItem!)
        }
        updateFretboardView()
    }
    
    
  

    //##########################################################
    // Window Controller overridden functions.
    //##########################################################
    func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
        return document?.undoManager!
    }
    
    override var windowNibName: String? {
        return "MainWindowController"
    }
    
    // Handles any initialization after the window controller's window has been loaded from its nib file.
    override func windowDidLoad() {
        super.windowDidLoad()
        
        modelIndex = 0
        
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
        
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(MainWindowController.reactToMouseUpEvent(_:)),
                                                         name: "noteViewMouseUpEvent",
                                                         object: nil)
        
        loadCurrentFretboard()
        
        // registers the NSTableView for drag reordering.
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
        showCalcNotes(showCalcNotesButton)

        if selectCalcNotesButton.state == 0 {
            selectCalcNotes(selectCalcNotesButton)
            
        }
      
        
        // If auto selecting additional notes is not enabled during modelUpate, reset controls.
        if selectAdditionalNotesButton.state == 0 {
            showAdditionalNotesButton.state = 0
        }
        

        // update the fretboardView.
        updateFretboardView()

    }
    
    func updateFretboardView() {
        fretboardView.updateSubviews(model.getFretboardArray())
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
            let noteModel = model.getFretboardArray()[index]
            
            // only edits the specified note: in the scale or not in the scale.
            if noteModel.getIsKept() != true {
                if noteModel.getIsInScale() == _isInScale {
                    noteModel.setIsDisplayed(_isDisplayed)
                    noteModel.setIsGhost(_isGhosted)
                    if _isInScale == true {
                        noteModel.setMyColor(model.getUserColor())
                    }
                }
            }
        }
        updateFretboardView()
    }
    
    func reactToMouseUpEvent(notification: NSNotification) {
        // If fretboard isn't locked.
        if model.getIsLocked() == 0 {
            // store the view number.
            let index = (notification.userInfo!["number"] as! Int)
            let noteModel = model.getFretboardArray()[index]
        
            // if myColor hasn't been updated to the new userColor, redraw.
            if noteModel.getMyColor() != model.getUserColor() {
                
                // Set the color correctly.
                noteModel.setMyColor(model.getUserColor())
                
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
            let noteModel = model.getFretboardArray()[index]
            
            // If the view is displayed, determine whether to keep.
            if noteModel.getIsDisplayed() == true {
                // If ghosted, don't keep
                if noteModel.getIsGhost() == true {
                    noteModel.setIsKept(false)
                }
                    // If unghosted, keep or unkeep depending on the value of 'doKeppt
                else {
                    noteModel.setIsKept(doKeep)
                    // If we've unSelected the note via unselectAll
                    // update the ghost value and display with current value.
                    if doKeep == false {
                        noteModel.setIsGhost(true)
                    }
                }
            }
        }
    }
    
    func updateToneArrayIntofretboardModel(toneArray: [NoteModel]) {
        for stringIndex in 0...5 {
            for noteIndex in 0...(NOTES_PER_STRING - 1){
                
                
                let noteModel = (model.getFretboardArray()[noteIndex + (stringIndex * NOTES_PER_STRING)])
                let zeroTo46Model = toneArray[noteIndex + offsets[stringIndex]]
                // For all noteModels not marked as kept, set the noteModel to the zeroTo46 Model.
                if noteModel.getIsKept() == false {
                    noteModel.setNoteModel(zeroTo46Model)
                }
            }
        }
    }
    
    

    // Load current fretboard
    
    func loadCurrentFretboard() {
        lockButton.state = model.getIsLocked()
        lockFretboard(lockButton)
        displayTitle!.stringValue = model.getFretboardTitle()
        
        // Load checkbox data, if necessary disable selection boxes.
        showCalcNotesButton.state = model.getShowCalcedNotes()
        if showCalcNotesButton.state == 0 {
            selectCalcNotesButton.enabled = false
        }
        else {
            selectCalcNotesButton.enabled = true
        }
        selectCalcNotesButton.state = model.getSelectCalcedNotes()
        
        showAdditionalNotesButton.state = model.getShowAdditionalNotes()
        if showAdditionalNotesButton.state == 0 {
            selectAdditionalNotesButton.enabled = false
        }
        else {
            selectAdditionalNotesButton.enabled = true
        }
        selectAdditionalNotesButton.state = model.getSelectAdditionalNotes()
        
        displayModePopUp.selectItemAtIndex(model.getDisplayMode())

        
        updateFretboardView()
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
    
    //##########################################################
    // TableViewDelegate.
    //##########################################################

    // Row Selection.
    func tableViewSelectionDidChange(notification: NSNotification) {
      // Update the view to display the selected fretboard.
        modelIndex = tableView.selectedRow
        loadCurrentFretboard()
        playlistPanel.makeKeyWindow()
    }
    
   
    
}



