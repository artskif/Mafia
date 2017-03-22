//
//  Game.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 22.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log

// класс описывающий состояние сеанса одной игры в Мафию
class Game {
    var state:DayNightState
    var players:[Player]
    var turns:[Turn]
    var accounts:[Account]
    
    init(){
        self.state = DayNightState.Day
        self.players = []
        self.turns = []
        
        let accountsStore =  NSKeyedUnarchiver.unarchiveObject(withFile: Account.ArchiveURL.path) as? [Account] ?? []
        self.accounts = accountsStore
    }
}
