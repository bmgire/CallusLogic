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
    
    @IBOutlet weak var  fretDisplayModePopUp: NSPopUpButton!
    
    
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
    
    @IBAction func updateFretDisplay(sender: NSPopUpButton) {
       
        fretboardView!.displayMode = sender.titleOfSelectedItem!
        fretboardView!.updateSubviews()
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
        scalePopUp!.selectItemAtIndex(scalePopUp!.indexOfItemWithTitle("Minor Pentatonic Scale"))
        
        fretDisplayModePopUp!.addItemWithTitle("Notes")
        fretDisplayModePopUp!.addItemWithTitle("Intervals")
        fretDisplayModePopUp!.addItemWithTitle("Numbers 0-11")
        fretDisplayModePopUp!.addItemWithTitle("Numbers 0-46")
        
        fretDisplayModePopUp!.selectItemAtIndex(0)
        updateFretboardModelAndViews()
    }
    
    
    func addScaleNamesToPopUp(){
        for index in 0...(fretboardModel.allScales.scaleArray.count - 1){
            scalePopUp!.addItemWithTitle(fretboardModel.allScales.scaleArray[index].scaleName)
        }
        
        scalePopUp!.menu?.insertItem(NSMenuItem.separatorItem(), atIndex: 14)
        scalePopUp!.menu?.insertItem(NSMenuItem.separatorItem(), atIndex: 22)
        scalePopUp!.menu?.insertItem(NSMenuItem.separatorItem(), atIndex: 31)
    }
    
    // update fretboardModel
    func updateFretboardModelAndViews() {
        // Update Model
        fretboardModel.updateWithValues(rootPopUp!.titleOfSelectedItem!,
                                        accidental: accidentalPopUp!.titleOfSelectedItem!,
                                        scaleName: scalePopUp!.titleOfSelectedItem!)
        // Update Display Mode.
        fretboardView.displayMode = fretDisplayModePopUp!.titleOfSelectedItem!
        // Update view
        fretboardView!.updateNoteModelArray(fretboardModel.fullFretboardArray)
        
        
        fretboardView.needsDisplay = true
    }
    
}

