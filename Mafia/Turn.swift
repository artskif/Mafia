//
//  Turn.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 22.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

class Turn{
    var number:Int
    var actions:[Action]

    init() {
        self.number = 0
        self.actions = []
    }
}
