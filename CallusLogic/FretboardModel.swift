//
//  FretboardModel.swift
//  CallusLogic
//
//  Copyright © 2016 Gire. All rights reserved.
//  This model is not very accurate, I need for this to hold all the information of the

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

