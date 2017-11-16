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
    
    fileprivate var fretboardModelArray: [FretboardModel] = [FretboardModel()]{
        didSet {
            
            tableView?.reloadData()
        }
    }
    
    fileprivate var model = FretboardModel()
    
    fileprivate var modelIndex: Int = 0 {
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
    
    @IBOutlet weak var zoomSlider: NSSlider!
    @IBOutlet weak var scrollView: NSScrollView!
    
    //##########################################################
    // MARK: - Getters and Setters.
    //##########################################################
    
    func getFretboardModelArray()-> [FretboardModel] {
        return fretboardModelArray
    }
    func setFretboardModelArray(_ newArray: [FretboardModel]) {
        fretboardModelArray = newArray
    }
    
    //##########################################################
    // MARK: - Action functions.
    //##########################################################
    
    
    @IBAction func addCalculatedNotes(_ sender: NSButton) {
        
        let undo = document?.undoManager!
        undo!.registerUndo(withTarget: self,
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
    
    
    @objc func setFretboardArray(_ array: AnyObject) {
        let undo = document?.undoManager!
        undo!.registerUndo(withTarget: self,
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
    @IBAction func addFretboardAction(_ sender: NSButton) {

        addFretboard(FretboardModel())
    }
    
    @objc func addFretboard(_ aModel: FretboardModel) {
        
        // Create undo
        let undo = document?.undoManager!
        undo!.registerUndo(withTarget: self,
                                     selector: #selector(removeFretboard(_:)),
                                     object: aModel)
        if !undo!.isUndoing {
                undo!.setActionName("Add Fretboard")
        }
        // add model and update view.
        fretboardModelArray.append(aModel)
        let row = IndexSet(integer: fretboardModelArray.count - 1)
        tableView.selectRowIndexes(row, byExtendingSelection: false)
    }
    
    
    // Remove a fretboard from the tableview.
    @IBAction func removeFretboardAction(_ sender: NSButton) {
        removeFretboard(model)
    }
    
    @objc func removeFretboard(_ aModel: AnyObject) {
        
        // Create undo
        let undo = document!.undoManager!
        undo!.registerUndo(withTarget: self,
                                     selector: #selector(addFretboard(_:)),
                                     object: aModel)
        if !undo!.isUndoing {
            undo!.setActionName("Remove Fretboard")
        }
        
        let index = fretboardModelArray.index(of: aModel as! FretboardModel)
        
        fretboardModelArray.remove(at: index!)
        tableView.reloadData()
        
        tableView.selectRowIndexes(IndexSet(integer: index! - 1), byExtendingSelection: false)
    }
    
    
    // Sets the tite thru the tableview.
    @IBAction func setTitleAction(_ sender: NSTextField) {
        
        setTitle(sender.stringValue)
    }
    
    @objc func setTitle(_ newTitle: String){
       
        let oldTitle = model.getFretboardTitle()
        // Create undo
        let undo = document!.undoManager!
        undo!.registerUndo(withTarget: self,
                                     selector: #selector(setTitle(_:)),
                                     object: oldTitle)
        
        if !undo!.isUndoing {
            undo!.setActionName("Set Title")
        }
        
        model.setFretboardTitle(newTitle)
        displayTitle.stringValue = newTitle
    }
    
    
    @IBAction func changeUserColor(_ sender: NSColorWell) {

        model.setUserColor(sender.color)
        model.setAllowsSelectAll(true)
        
    }

    
    @IBAction func selectAllAction(_ sender: NSButton){
        
        if model.getAllowsSelectAll() {
            
            // Create undo
            let undo = document!.undoManager!
            // (undo!.prepare(withInvocationTarget: self) as AnyObject).setFretboardArray(model.getFretboardArrayCopy())
            undo!.registerUndo(withTarget: self,
                               selector: #selector(setFretboardArray(_:)),
                               object: model.getFretboardArrayCopy())
            
            if !undo!.isUndoing {
                undo!.setActionName("Select All")
            }
            
            showNotesOnFretboard(true, _isDisplayed: true, _isGhosted: false)
            
            // If show Additional Notes is selected, also show additional notes.
            if showAdditionalNotesButton.state == NSControl.StateValue.on {
                showNotesOnFretboard(false, _isDisplayed: true, _isGhosted: false)
            }
            
            // update which buttons work.
            model.setAllowsGhostAll(true)
            model.setAllowsSelectAll(true)
        }
    }
    
    
    // Unselect all.
    @IBAction func ghostAllAction(_ sender: NSButton) {
        if model.getAllowsGhostAll() {
            // Create undo
            let undo = document!.undoManager!
            //(undo!.prepare(withInvocationTarget: self) as AnyObject).setFretboardArray(model.getFretboardArrayCopy())
            undo!.registerUndo(withTarget: self,
                               selector: #selector(setFretboardArray(_:)),
                               object: model.getFretboardArrayCopy())
            
            if !undo!.isUndoing {
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
    @IBAction func clearGhostsAction(_ sender: NSButton) {
        if model.getAllowsClear() {
            
            let undo = document!.undoManager!
            //(undo!.prepare(withInvocationTarget: self) as AnyObject).setFretboardArray(model.getFretboardArrayCopy())
            undo!.registerUndo(withTarget: self,
                               selector: #selector(setFretboardArray(_:)),
                               object: model.getFretboardArrayCopy())
            
            if !undo!.isUndoing {
                undo!.setActionName("Clear Unselected")
            }
            
            keepOrUnkeepSelectedNotes(true)
            showAdditionalNotesButton.state = NSControl.StateValue(rawValue: 0)
            
            showNotesOnFretboard(true, _isDisplayed: false, _isGhosted: true)
            showNotesOnFretboard(false, _isDisplayed: false, _isGhosted: true)
            
            // Update which buttons work.
            model.setAllowsGhostAll(true)
            model.setAllowsSelectAll(true)
            model.setAllowsClear(false)
            
            if showAdditionalNotesButton.state.rawValue == 1 {
                showAdditionalNotesButton.state = NSControl.StateValue(rawValue: 0)
            }
        }
    }
    
 
    // Shows additional notes.
    @IBAction func showAdditionalNotesAction(_ sender: NSButton) {
        
        let revertTo = StateAndArray()
        revertTo.array = model.getFretboardArrayCopy()
        revertTo.showAdditionalState = (sender.state == NSControl.StateValue.off ? 0 : 1)
        
        let undo = document!.undoManager!
        (undo!.prepare(withInvocationTarget: self) as AnyObject).showAdditionalNotes(revertTo)
        
        if !undo!.isUndoing {
            undo!.setActionName("Show Additional Notes")
        }
        
        // Make Changes.
        model.setShowAdditionalNotes(sender.state.rawValue)
        
        // If the button is checked.
        if sender.state != NSControl.StateValue.off {
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
    
    
    @objc func showAdditionalNotes(_ stateAndArray: AnyObject) {
        let copy = stateAndArray as! StateAndArray
        let revertTo = StateAndArray()
        revertTo.array = model.getFretboardArrayCopy()
        revertTo.showAdditionalState = (showAdditionalNotesButton.state == NSControl.StateValue.on ? 0 : 1)
        
        let undo = document!.undoManager!
        (undo!.prepare(withInvocationTarget: self) as AnyObject).showAdditionalNotes(revertTo)
        
        if !undo!.isUndoing {
            undo!.setActionName("Show Additional Notes")
        }
        
        // Make changes
        showAdditionalNotesButton.state = NSControl.StateValue(rawValue: copy.showAdditionalState)
        model.setShowAdditionalNotes(copy.showAdditionalState)
        model.setFretboardArray(copy.array)
        updateFretboardView()
    }
    
    @IBAction func lockFretboard(_ sender: NSButton) {
        // If the lock button is checked,
        if sender.state == NSControl.StateValue.on {
            // Disable all editing capabilities.
            calculatorView.isHidden = true
            customizeView.isHidden = true
            removeFretboard.isEnabled = false
            }
        // Else, the button isn't locked,
        else {
            calculatorView.isHidden = false
            customizeView.isHidden = false
            removeFretboard.isEnabled = true
        }
        
        model.setIsLocked(sender.state.rawValue)
    }
    
    @IBAction func updateDisplayModeAction(_ sender: NSPopUpButton) {
        
        if sender.indexOfSelectedItem != model.getDisplayMode(){
            updateDisplayMode(sender.indexOfSelectedItem)
        }
    }
    
    @IBAction func zoom(_ sender: NSSlider){
        let ratio = CGFloat(sender.doubleValue / sender.maxValue)
        scrollView.magnification = ratio
       
       
        model.setZoomLevel(sender.doubleValue)
        
        print(model.getZoomLevel())
        // if zooming out, perhaps keep the window scrolled left.
        // 0.760651041666667 = ratio to 12th fret at minimum screen size. 
    
        
       
       
        //The bottom value is used to keep the height of the fretboard image centered.
        let bottom = CGFloat(400 * (1 - ratio))
    
        
        // Adjusts the contentView (aka clipview) to
        let insets = NSEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
        scrollView.contentView.contentInsets = insets
        
        
        // Scroll all the way to the left on every Zoom.
        // Note I made the scrolliew non-continuous to limit zoom calculations.
        scrollView.contentView.scroll(to: NSPoint(x: 0, y: 10 - bottom))
    }
    
    
    
    @objc func updateDisplayMode(_ newIndex: Int) {
        let undo = document!.undoManager!
        (undo!.prepare(withInvocationTarget: self) as AnyObject).updateDisplayMode(model.getDisplayMode())
        
        if !undo!.isUndoing {
            undo!.setActionName("Change Display Mode")
        }
        
        displayModePopUp.selectItem(at: newIndex)
        model.setDisplayMode(newIndex)
        
        // Go through the fretboard array and change the dipslaymode to whatever is selected.
        for index in 0...137 {
            model.getFretboardArray()[index].setDisplayMode(displayModePopUp.itemTitle(at: newIndex))
        }
        updateFretboardView()
    }
    

    //##########################################################
    // Window Controller overridden functions.
    //##########################################################
    func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
        return document?.undoManager!
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("MainWindowController")
    }
    
    // Handles any initialization after the window controller's window has been loaded from its nib file.
    override func windowDidLoad() {
        super.windowDidLoad()
        
        //window?.restorable = true
        
        modelIndex = 0
        
        // Build PopUps.
        accidentalPopUp!.addItem(withTitle: "Natural")
        accidentalPopUp!.addItem(withTitle: "b")
        accidentalPopUp!.addItem(withTitle: "#")
        accidentalPopUp!.selectItem(at: 0)
        
        rootPopUp!.addItem(withTitle: "A")
        rootPopUp!.addItem(withTitle: "B")
        rootPopUp!.addItem(withTitle: "C")
        rootPopUp!.addItem(withTitle: "D")
        rootPopUp!.addItem(withTitle: "E")
        rootPopUp!.addItem(withTitle: "F")
        rootPopUp!.addItem(withTitle: "G")
        rootPopUp!.selectItem(at: 4)
        
        addScaleNamesToPopUp()
        scalePopUp!.selectItem(at: scalePopUp!.indexOfItem(withTitle: "Minor Pentatonic Scale"))
        
        displayModePopUp!.addItem(withTitle: "Notes")
        displayModePopUp!.addItem(withTitle: "Intervals")
        displayModePopUp!.addItem(withTitle: "Numbers 0-11")
        displayModePopUp!.addItem(withTitle: "Numbers 0-46")
        
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(MainWindowController.reactToMouseUpEvent(_:)),
                                                         name: NSNotification.Name(rawValue: "noteViewMouseUpEvent"),
                                                         object: nil)
        
        loadCurrentFretboard()
        
        //Set zoomSlider and call the zoom function appropriately
        zoomSlider.doubleValue = model.getZoomLevel()
        zoom(zoomSlider)
        
        // registers the NSTableView for drag reordering.
        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        // Close the color panel if still open.
        NSColorPanel.shared.close()
    }
    
    
    //##########################################################
    // Custom class functions.
    //##########################################################
    
    // Adds the scale names to the Scale PopUp
    func addScaleNamesToPopUp(){
        for index in 0...(AllScales().getScaleArray().count - 1){
            scalePopUp!.addItem(withTitle: AllScales().getScaleArray()[index].getScaleName())
        }
        // Adds separator items to make the scales popUp easier to read.
        scalePopUp!.menu?.insertItem(NSMenuItem.separator(), at: 14)
        scalePopUp!.menu?.insertItem(NSMenuItem.separator(), at: 22)
        scalePopUp!.menu?.insertItem(NSMenuItem.separator(), at: 31)
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
        NSColorPanel.shared.close()
                
        fretboardView.updateSubviews(model.getFretboardArray())
    }
    
    
    func fillSpacesWithChromatic()
    {
        let chromatic = ZeroTo46ToneCalculator()
        chromatic.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                   myAccidental: accidentalPopUp!.titleOfSelectedItem!,
                                   scaleName: "Chromatic Scale",
                                   displayMode: displayModePopUp!.titleOfSelectedItem!,
                                   myCalcColor: NSColor.red)
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
    
    
    func showNotesOnFretboard( _ _isInScale: Bool, _isDisplayed: Bool, _isGhosted: Bool) {
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
    
    @objc func reactToMouseUpEvent(_ notification: Notification) {
        // If fretboard isn't locked.
        if model.getIsLocked() == 0 {
            
            // store the view number.
            let index = ((notification as NSNotification).userInfo!["number"] as! Int)
            let noteModel = model.getFretboardArray()[index]
        
           mouseNoteSelection(noteModel)
        }
    }
    
    func mouseNoteSelection(_ noteModel: NoteModel) {
        
        // Setup Undo
        let undo = document!.undoManager!
        //(undo!.prepare(withInvocationTarget: self) as AnyObject).setFretboardArray(model.getFretboardArrayCopy())
        undo!.registerUndo(withTarget: self,
                           selector: #selector(setFretboardArray(_:)),
                           object: model.getFretboardArrayCopy())
        
        if !undo!.isUndoing {
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
    func keepOrUnkeepSelectedNotes(_ doKeep: Bool) {
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
    func updateToneArrayIntofretboardModel(_ toneArray: [NoteModel]) {
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
        lockButton.state = NSControl.StateValue(rawValue: model.getIsLocked())
        lockFretboard(lockButton)
        
        displayTitle!.stringValue = model.getFretboardTitle()
        
        showAdditionalNotesButton.state = NSControl.StateValue(rawValue: model.getShowAdditionalNotes())
        
        displayModePopUp.selectItem(at: model.getDisplayMode())
        
        updateFretboardView()
        model.setUserColor(colorWell.color)
    }
    
    
    func reArrangeModelArray(_ source: Int, destination: Int) {
        
        let model = fretboardModelArray[source]
        
        fretboardModelArray.insert(model, at: destination)
        
        // If the destination is higher than the source, remove the source.
        // Else remove one after the source.
        if  destination > source {
            fretboardModelArray.remove(at: source)
        }
        else{
            fretboardModelArray.remove(at: source + 1)
        }
    }
    

    //##########################################################
    // TableViewDataSource functions.
    //##########################################################
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        let count = fretboardModelArray.count
        
        // Disable remove fretboard button if only ther is one fretboard.
        if count == 1 {
            removeFretboard.isEnabled = false
        }
        else {
            removeFretboard.isEnabled = true
        }
        return count
    }
    
    // Return the object value for the column and row.
    func tableView(_ tableView: NSTableView,
                   objectValueFor tableColumn: NSTableColumn?,
                                             row: Int) -> Any? {
        return fretboardModelArray[row].getFretboardTitle()
    }
    
    
    // Writes the selected row to the pasteboard.
    func tableView(_ tableView: NSTableView,
                   writeRowsWith rowIndexes: IndexSet,
                                        to pboard: NSPasteboard) -> Bool {
        
                    let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
            
            pboard.declareTypes([NSPasteboard.PasteboardType.string], owner: self)
            pboard.setData(data, forType:  NSPasteboard.PasteboardType(rawValue: "rowData"))
            modelIndex = rowIndexes.first!
            return true
      }
    
    
    // Sets the type of drag and drop to perform.
    func tableView(_ tableView: NSTableView,
                   validateDrop info: NSDraggingInfo,
                                proposedRow row: Int,
                                            proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        if (dropOperation == .above) {
            return .move
        }
        return NSDragOperation()
    }
    
    
    // reorganizes the data model for the drop.
    func tableView(_ tableView: NSTableView,
                     acceptDrop info: NSDraggingInfo,
                                row: Int,
                                dropOperation: NSTableView.DropOperation) -> Bool {
        
        reArrangeModelArray(modelIndex, destination: row)
        tableView.reloadData()

        return true
    }
    
    //##########################################################
    // TableViewDelegate.
    //##########################################################

    // Row Selection.
    func tableViewSelectionDidChange(_ notification: Notification) {
        // Update the view to display the selected fretboard.
        modelIndex = tableView.selectedRow
        loadCurrentFretboard()
    }
}



