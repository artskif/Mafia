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
        let firstTurn = Turn(turnNumber: 1)
        self.turns = [firstTurn]
        
        let accountsStore =  NSKeyedUnarchiver.unarchiveObject(withFile: Account.ArchiveURL.path) as? [Account] ?? []
        self.accounts = accountsStore
    }
    
    // Вернуть текущий ход
    func getCurrentTurn() -> Turn {
        guard let currentTurn = self.turns.last else {
            fatalError("The game have't current turn.")
        }
        
        return currentTurn
    }
    
    // Начинаем новый ход
    func startNewTurn(){
        let newTurn = Turn(turnNumber: game.getNextTurnNumber())
        self.turns.append(newTurn)
    }
    
    // Получить порядковый номер текущего хода
    func getTurnNumber() -> Int {
        return self.getCurrentTurn().number
    }
    
    // Получить порядковый номер следующего хода
    func getNextTurnNumber() -> Int {
        return self.getTurnNumber()+1
    }
}
