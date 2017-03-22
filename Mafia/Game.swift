//
//  Game.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 22.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

// класс описывающий состояние сеанса одной игры в Мафию
class Game {
    var state:DayNightState
    var players:[Player]
    var turns:[Turn]
    
    init(){
        self.state = DayNightState.Day
        self.players = []
        self.turns = []
    }
}
