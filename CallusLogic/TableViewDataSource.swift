//
//  TableViewDataSource.swift
//  CallusLogic
//
//  Created by Ben Gire on 8/2/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Cocoa

class TableViewDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    private var nameArray: [String] = []
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return nameArray.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return nameArray[row]
    }
    
    
}
