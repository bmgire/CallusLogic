//
//  FretboardModel.swift
//  CallusLogic
//
//  Created by Ben Gire on 7/10/16.
//  Copyright © 2016 Gire. All rights reserved.
//

import Foundation


class FretboardModel {
    let array: [NoteModel]
    
    init(){
        // Build 47 item array of NoteModels.
        var temp : [NoteModel] = []
        for _ in 0...46 {
            temp.append(NoteModel())
        }
        array = temp
    }
}

