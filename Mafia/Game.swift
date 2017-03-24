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
        
        // Достаем из хранилища сохраненные аккаунты если имеются
        self.accounts =  Game.loadAccounts()
    }
    
    // MARK: - Методы Ходов(Turn)
    
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
    
    // MARK: - Методы хранения данных
    
    // Сохранение игроков в постоянное хранилище телефона
    func saveAccounts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(game.accounts, toFile: Account.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Accounts successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save accounts...", log: OSLog.default, type: .error)
        }
    }
    
    // Выгрузка игроков из хранилища телефона
    class func loadAccounts() -> [Account] {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Account.ArchiveURL.path) as? [Account] ?? []
    }
    
    // Загрузка тестовых данных участников игры
    private func loadSamplePlayers() {
        guard let player1 = Player(name: "Игрок 1")
            else {
                fatalError("Unable to instantiate player1")
        }
        
        guard let player2 = Player(name: "Игрок 2")
            else {
                fatalError("Unable to instantiate player2")
        }
        
        guard let player3 = Player(name: "Игрок 3")
            else {
                fatalError("Unable to instantiate player3")
        }
        
        game.players += [player1, player2, player3]
    }
}
