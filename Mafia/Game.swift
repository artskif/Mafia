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
    
    // MARK: - Поля класса
    
    var state:DayNightState
    private var _players:[Player]
    var accounts:[Account]
    var roles:Dictionary<Int, Role>
    var isStarted:Bool
    var turnNumber:Int
    var turnTextMessage:String
    var currentTurnDead:Player?
    
    
    init(){
        self.state = DayNightState.Day
        self._players = []
        self.roles = [:]
        self.isStarted = false
        self.turnNumber = 1
        self.turnTextMessage = "Никто не умер"
        self.currentTurnDead = nil
        
        // Достаем из хранилища сохраненные аккаунты если имеются
        self.accounts =  Game.loadAccounts()
    }
   
    // MARK: - Методы Игроков(Players)
    
    // Добавляем нового участника игры
    func addPlayer(player:Player) {
        self._players.append(player)
        self.reloadRoles()
    }
    
    // Получить одного игрока
    func getPlayer(at: Int) -> Player {
        return self._players[at]
    }
    
    // Удаляем участника игры
    func removePlayer(at: Int) {
        self._players.remove(at: at)
        self.reloadRoles()
    }
    
    // Обновляем участника игры
    func setPlayer(at: Int, element: Player) {
        self._players[at] = element
        self.reloadRoles()
    }
    
    // Текущее количество участников игры
    func countPlayers() -> Int {
        return self._players.count
    }
    
    // Обработать конец хода (высчитываем кто убит, кто молчит и тд)
    func handleTurnActions() {
        
        self.turnTextMessage = "" // Сбрасываем сообщения в конце хода
        self.currentTurnDead = nil // Сбрасываем текущего умершего игрока
        
        // Проверим каждого игрока, что с ним произошло за текущий ход
        // (и изменим его статус, а так же сформируем сообщения о том что произошло за ход)
        for player in _players {
            if player.actionCheck(action: ActionType.CitizenKill) {
                player.stateAlive = AliveState.Dead
                self.currentTurnDead = player
                self.turnTextMessage += "Горожане убили \(player.name) (\(player.role.description))\n"
            }
            if player.actionCheck(action: ActionType.MafiaKill) && !player.actionCheck(action: ActionType.Heal) && player.role != Role.Undead {
                player.stateAlive = AliveState.Dead
                self.currentTurnDead = player
                self.turnTextMessage += "Мафия убила \(player.name) (\(player.role.description)\n"
            }
            if player.actionCheck(action: ActionType.ProstituteSilence) {
                self.turnTextMessage += "Молчит \(player.name)\n"
            }
        }
        if self.turnTextMessage.isEmpty {self.turnTextMessage = "Никто не умер"}
        
        // Подсчитываем рейтинг в конце хода
        Rating.calculateTurnRating(players: &self._players, turnNumber: self.getCurrentTurnNumber(), whoDead: self.currentTurnDead, dayState: self.state)
        
        self.reloadRoles() // Если кто-то умер нужно пересчитать существующие в игре роли

        // Проверяем не закончилась ли игра
        if self.checkEndOfGame() {
            self.turnTextMessage += "Игра окончена"
        }
    }
    
    // Проверяем не закончилась ли игра
    func checkEndOfGame() -> Bool {
        return false
    }
    
    // MARK: - Методы Ролей(Role)
    
    // Получаем все оставшиеся игровые роли
    func getGameRoles() -> Dictionary<Int, Role> {
        var newRoles: Dictionary<Int, Role> = [:]
        for p in self._players {
            if p.stateAlive == AliveState.Live {
                newRoles[p.role.rawValue] = Role(rawValue: p.role.rawValue)
            }
        }
        return newRoles
    }
    
    // Пересчитываем оставшиеся игровые роли
    func reloadRoles(){
        self.roles = self.getGameRoles()
    }
    
    // MARK: - Методы Ходов(Turn)
    
    // Вернуть текущий ход
    func getCurrentTurnNumber() -> Int {
        return self.turnNumber
    }
    
    // Начинаем новый ход
    func startNewTurn(){
        self.turnNumber += 1
        
        // Меняем время суток (день/ночь)
        if self.state == DayNightState.Night {
            self.state = DayNightState.Day
        } else {
            self.state = DayNightState.Night
        }
    }
    
    // Получить порядковый номер следующего хода
    func getNextTurnNumber() -> Int {
        return self.turnNumber+1
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
        
        game._players += [player1, player2, player3]
    }
}
