//
//  Action.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 22.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

class Action {
    var actionType:ActionType
    var player:Player
    
    init(actionType:ActionType, player: Player){
        self.actionType = actionType
        self.player = player
    }
}
