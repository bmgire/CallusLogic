//
//  MainWindowController.swift
//  StringNotesCalculator
//
//  Copyright © 2016 Gire. All rights reserved.
/*  This Window controller builds fretboards on the FretboardView class
    via the FretboardCalculator class and the customize options. 
    Note: save capabilities have not yet been implemented    */

import Cocoa


class StateAndArray {
    var array: [NoteModel] = []
    var showAdditionalState = 0

}


class MainWindowController: NSWindowController, NSTableViewDataSource , NSTableViewDelegate, NSWindowDelegate{
    
    //##########################################################
    // Class Variables (except the outlets)
    //##########################################################
    
    // Offsets for toneNumber for each open string in standard tuning.
    let offsets = [0, 5, 10, 15, 19, 24]
    
    // Calculates 46 tone arrays.
    let zeroTo46ToneCalculator = ZeroTo46ToneCalculator()
    
    let NOTES_PER_STRING = 23
    
    private var fretboardModelArray: [FretboardModel] = [FretboardModel()]{
        didSet {
            
            tableView?.reloadData()
        }
    }
    
    private var model = FretboardModel()
    
    private var modelIndex: Int = 0 {
        didSet{
            model = fretboardModelArray[modelIndex]
        }
    }
    
   // private var sourceIndex = 0
    
    //##########################################################
    // Outlets to fretboard controls.
    //##########################################################
    
    // Calculator controls.
    @IBOutlet weak var rootPopUp: NSPopUpButton!
    @IBOutlet weak var accidentalPopUp: NSPopUpButton!
    @IBOutlet weak var scalePopUp: NSPopUpButton!
    
    @IBOutlet weak var fretboardView: FretboardView!
    @IBOutlet weak var lockButton: NSButton!
    
    // Fretboard title outlet.
    @IBOutlet weak var displayTitle: NSTextField!

    @IBOutlet weak var showAdditionalNotesButton: NSButton!
   
    @IBOutlet weak var displayModePopUp: NSPopUpButton!

    @IBOutlet weak var clearUnselected: NSButton!
    @IBOutlet weak var unSelectAllButton: NSButton!
    @IBOutlet weak var colorWell: NSColorWell!
    
    @IBOutlet weak var customizeView: NSView!
    @IBOutlet weak var calculatorView: NSView!
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var addFretboard: NSButton!
    @IBOutlet weak var removeFretboard: NSButton!
    
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
    
    
    @IBAction func addCalculatedNotes(sender: NSButton) {
        
        let undo = document?.undoManager!
        undo!.registerUndoWithTarget(self,
                                     selector: #selector(setFretboardArray(_:)),
                                     object: model.getFretboardArrayCopy())
        undo!.setActionName("Add Notes")
        
        // Calculate and display notes.
        keepOrUnkeepSelectedNotes(true)
        updateZeroTo46ToneCalculator()
        updatefretboardModel()
        
        // update which buttons work.
        model.setAllowsSelectAll(true)
        model.setAllowsClear(true)
    }
    
    
    func setFretboardArray(array: AnyObject) {
        let undo = document?.undoManager!
        undo!.registerUndoWithTarget(self,
                                     selector: #selector(setFretboardArray(_:)),
                                     object: model.getFretboardArrayCopy())
        
        model.setFretboardArray(array as! [NoteModel])
        
        // update which buttons work.
        model.setAllowsGhostAll(true)
        model.setAllowsSelectAll(true)
        model.setAllowsClear(true)
        
        updateFretboardView()
    }
    
    
    // Adds a fretboard to the table view.
    @IBAction func addFretboardAction(sender: NSButton) {

        addFretboard(FretboardModel())
    }
    
    func addFretboard(aModel: FretboardModel) {
        
        // Create undo
        let undo = document?.undoManager!
        undo!.registerUndoWithTarget(self,
                                     selector: #selector(removeFretboard(_:)),
                                     object: aModel)
        if !undo!.undoing {
                undo!.setActionName("Add Fretboard")
        }
        // add model and update view.
        fretboardModelArray.append(aModel)
        let row = NSIndexSet(index: fretboardModelArray.count - 1)
        tableView.selectRowIndexes(row, byExtendingSelection: false)
    }
    
    
    // Remove a fretboard from the tableview.
    @IBAction func removeFretboardAction(sender: NSButton) {
        removeFretboard(model)
    }
    
    func removeFretboard(aModel: AnyObject) {
        
        // Create undo
        let undo = document!.undoManager!
        undo!.registerUndoWithTarget(self,
                                     selector: #selector(addFretboard(_:)),
                                     object: aModel)
        if !undo!.undoing {
            undo!.setActionName("Remove Fretboard")
        }
        
        let index = fretboardModelArray.indexOf(aModel as! FretboardModel)
        
        fretboardModelArray.removeAtIndex(index!)
        tableView.reloadData()
        
        tableView.selectRowIndexes(NSIndexSet(index: index! - 1), byExtendingSelection: false)
    }
    
    
    // Sets the tite thru the tableview.
    @IBAction func setTitleAction(sender: NSTextField) {
        
        setTitle(sender.stringValue)
    }
    
    func setTitle(newTitle: String){
       
        let oldTitle = model.getFretboardTitle()
        // Create undo
        let undo = document!.undoManager!
        undo!.registerUndoWithTarget(self,
                                     selector: #selector(setTitle(_:)),
                                     object: oldTitle)
        
        if !undo!.undoing {
            undo!.setActionName("Set Title")
        }
        
        model.setFretboardTitle(newTitle)
        displayTitle.stringValue = newTitle
    }
    
    
    @IBAction func changeUserColor(sender: NSColorWell) {

        model.setUserColor(sender.color)
        model.setAllowsSelectAll(true)
        
    }

    
    @IBAction func selectAllAction(sender: NSButton){
        
        if model.getAllowsSelectAll() {
            
            // Create undo
            let undo = document!.undoManager!
            undo!.prepareWithInvocationTarget(self).setFretboardArray(model.getFretboardArrayCopy())
            
            if !undo!.undoing {
                undo!.setActionName("Select All")
            }
            
            showNotesOnFretboard(true, _isDisplayed: true, _isGhosted: false)
            
            // If show Additional Notes is selected, also show additional notes.
            if showAdditionalNotesButton.state == NSOnState {
                showNotesOnFretboard(false, _isDisplayed: true, _isGhosted: false)
            }
            
            // update which buttons work.
            model.setAllowsGhostAll(true)
            model.setAllowsSelectAll(true)
        }
    }
    
    
    // Unselect all.
    @IBAction func ghostAllAction(sender: NSButton) {
        if model.getAllowsGhostAll() {
            // Create undo
            let undo = document!.undoManager!
            undo!.prepareWithInvocationTarget(self).setFretboardArray(model.getFretboardArrayCopy())
            
            if !undo!.undoing {
                undo!.setActionName("Ghost All")
            }

            // update which buttons work.
            model.setAllowsGhostAll(false)
            model.setAllowsSelectAll(true)
            model.setAllowsClear(true)
           
            keepOrUnkeepSelectedNotes(false)
            showNotesOnFretboard(true, _isDisplayed: true, _isGhosted: true)
        }
    }
    
    
    // Clear unselected
    @IBAction func clearGhostsAction(sender: NSButton) {
        if model.getAllowsClear() {
            
            let undo = document!.undoManager!
            undo!.prepareWithInvocationTarget(self).setFretboardArray(model.getFretboardArrayCopy())
            
            if !undo!.undoing {
                undo!.setActionName("Clear Unselected")
            }
            
            keepOrUnkeepSelectedNotes(true)
            showAdditionalNotesButton.state = 0
            
            showNotesOnFretboard(true, _isDisplayed: false, _isGhosted: true)
            showNotesOnFretboard(false, _isDisplayed: false, _isGhosted: true)
            
            // Update which buttons work.
            model.setAllowsGhostAll(true)
            model.setAllowsSelectAll(true)
            model.setAllowsClear(false)
            
            if showAdditionalNotesButton.state == 1 {
                showAdditionalNotesButton.state = 0
            }
        }
    }
    
 
    // Shows additional notes.
    @IBAction func showAdditionalNotesAction(sender: NSButton) {
        
        let revertTo = StateAndArray()
        revertTo.array = model.getFretboardArrayCopy()
        revertTo.showAdditionalState = (sender.state == NSOnState ? NSOffState : NSOnState)
        
        let undo = document!.undoManager!
        undo!.prepareWithInvocationTarget(self).showAdditionalNotes(revertTo)
        
        if !undo!.undoing {
            undo!.setActionName("Show Additional Notes")
        }
        
        // Make Changes.
        model.setShowAdditionalNotes(sender.state)
        
        // If the button is checked.
        if sender.state != 0 {
            // Show chromatic notes.
            showNotesOnFretboard(false, _isDisplayed: true, _isGhosted: true)
            
            // update which buttons work.
            model.setAllowsSelectAll(true)
            model.setAllowsClear(true)
            
        }
            // Hide chromatic notes that aren't in the scale.
        else {
            showNotesOnFretboard(false, _isDisplayed: false, _isGhosted: true)
        }
    }
    
    
    func showAdditionalNotes(stateAndArray: AnyObject) {
        let copy = stateAndArray as! StateAndArray
        let revertTo = StateAndArray()
        revertTo.array = model.getFretboardArrayCopy()
        revertTo.showAdditionalState = (showAdditionalNotesButton.state == NSOnState ? NSOffState : NSOnState)
        
        let undo = document!.undoManager!
        undo!.prepareWithInvocationTarget(self).showAdditionalNotes(revertTo)
        
        if !undo!.undoing {
            undo!.setActionName("Show Additional Notes")
        }
        
        // Make changes
        showAdditionalNotesButton.state = copy.showAdditionalState
        model.setShowAdditionalNotes(copy.showAdditionalState)
        model.setFretboardArray(copy.array)
        updateFretboardView()
    }
    
    @IBAction func lockFretboard(sender: NSButton) {
        // If the lock button is checked,
        if sender.state != 0 {
            // Disable all editing capabilities.
            calculatorView.hidden = true
            customizeView.hidden = true
            }
        // Else, the button isn't locked,
        else {
            calculatorView.hidden = false
            customizeView.hidden = false
        }
        
        model.setIsLocked(sender.state)
    }
    
    @IBAction func updateDisplayModeAction(sender: NSPopUpButton) {
        
        if sender.indexOfSelectedItem != model.getDisplayMode(){
            updateDisplayMode(sender.indexOfSelectedItem)
        }
    }
    
    func updateDisplayMode(newIndex: Int) {
        let undo = document!.undoManager!
        undo!.prepareWithInvocationTarget(self).updateDisplayMode(model.getDisplayMode())
        
        if !undo!.undoing {
            undo!.setActionName("Change Display Mode")
        }
        
        displayModePopUp.selectItemAtIndex(newIndex)
        model.setDisplayMode(newIndex)
        
        // Go through the fretboard array and change the dipslaymode to whatever is selected.
        for index in 0...137 {
            model.getFretboardArray()[index].setDisplayMode(displayModePopUp.itemTitleAtIndex(newIndex))
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
        
        //window?.restorable = true
        
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
    
    override func mouseDown(theEvent: NSEvent) {
        // Close the color panel if still open.
        NSColorPanel.sharedColorPanel().close()
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
                                        displayMode: displayModePopUp!.titleOfSelectedItem!,
                                        myCalcColor: model.getUserColor())
        fillSpacesWithChromatic()
    }
    
    
    func updatefretboardModel() {
        updateToneArrayIntofretboardModel(zeroTo46ToneCalculator.getZeroTo46ToneArray())
    
        updateDisplayModeAction(displayModePopUp)
        
        showNotesOnFretboard(true, _isDisplayed: true, _isGhosted: true)
        
        updateFretboardView()
    }
    
    
    func updateFretboardView() {
        // Close the color panel if still open.
        NSColorPanel.sharedColorPanel().close()
                
        fretboardView.updateSubviews(model.getFretboardArray())
    }
    
    
    func fillSpacesWithChromatic()
    {
        let chromatic = ZeroTo46ToneCalculator()
        chromatic.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                   myAccidental: accidentalPopUp!.titleOfSelectedItem!,
                                   scaleName: "Chromatic Scale",
                                   displayMode: displayModePopUp!.titleOfSelectedItem!,
                                   myCalcColor: NSColor.redColor())
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
        
           mouseNoteSelection(noteModel)
        }
    }
    
    func mouseNoteSelection(noteModel: NoteModel) {
        
        // Setup Undo
        let undo = document!.undoManager!
        undo!.prepareWithInvocationTarget(self).setFretboardArray(model.getFretboardArrayCopy())
        
        if !undo!.undoing {
            undo!.setActionName("Select Note")
        }
        
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

        // update which buttons work.
        model.setAllowsGhostAll(true)
        model.setAllowsSelectAll(true)
        model.setAllowsClear(true)
        
        updateFretboardView()
    }
    
    //
    func keepOrUnkeepSelectedNotes(doKeep: Bool) {
        for index in 0...137 {
            let noteModel = model.getFretboardArray()[index]
            // If ghosted, don't keep
            if noteModel.getIsGhost() == true {
                noteModel.setIsKept(false)
            }
                // If unghosted (selected), keep or unkeep depending on the value of 'doKept
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
    
    // Loads note models into unselected/unkept notes.
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
    
    
    // Loads values from the current model.
    func loadCurrentFretboard() {
        lockButton.state = model.getIsLocked()
        lockFretboard(lockButton)
        
        displayTitle!.stringValue = model.getFretboardTitle()
        
        showAdditionalNotesButton.state = model.getShowAdditionalNotes()
        
        displayModePopUp.selectItemAtIndex(model.getDisplayMode())
        
        updateFretboardView()
        model.setUserColor(colorWell.color)
    }
    
    
    func reArrangeModelArray(source: Int, destination: Int) {
        
        let model = fretboardModelArray[source]
        
        fretboardModelArray.insert(model, atIndex: destination)
        
        // If the destination is higher than the source, remove the source.
        // Else remove one after the source.
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
        let count = fretboardModelArray.count
        
        // Disable remove fretboard button if only ther is one fretboard.
        if count == 1 {
            removeFretboard.enabled = false
        }
        else {
            removeFretboard.enabled = true
        }
        return count
    }
    
    // Return the object value for the column and row.
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
            modelIndex = rowIndexes.firstIndex
            return true
      }
    
    
    // Sets the type of drag and drop to perform.
    func tableView(tableView: NSTableView,
                   validateDrop info: NSDraggingInfo,
                                proposedRow row: Int,
                                            proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        
        if (dropOperation == .Above) {
            return .Move
        }
        return .None
    }
    
    
    // reorganizes the data model for the drop.
    func tableView(tableView: NSTableView,
                     acceptDrop info: NSDraggingInfo,
                                row: Int,
                                dropOperation: NSTableViewDropOperation) -> Bool {
        
        reArrangeModelArray(modelIndex, destination: row)
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
    }
}



