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
    
    var state:DayNightState // Состояние игры День/Ночь
    private var _players:[Player] // Участники игры
    var accounts:[Account] // Зарегистрированные пользователи игры
    var roles:Dictionary<Int, Role> // Роли игры
    var isStarted:Bool // Игра началась
    var isFinished:Bool // Игра закончилась
    var turnNumber:Int // Номер хода
    var turnTextMessage:String // Сообщение конца хода
    var currentTurnDead:[Player] // Текущие мертвые пользователи
    
    
    init(){
        self.state = DayNightState.Day
        self._players = []
        self.roles = [:]
        self.isStarted = false
        self.turnNumber = 1
        self.turnTextMessage = "Никто не умер"
        self.currentTurnDead = []
        self.isFinished = false
        
        // Достаем из хранилища сохраненные аккаунты если имеются
        // (используем статичный метод тк вызываем в инициализаторе)
        self.accounts =  Game.loadAccounts()
    }
   
    // MARK: - Методы Игроков(Players)
    
    // Добавляем нового участника игры
    func addPlayer(player:Player) {
        self._players.append(player)
        self.reloadRoles()
    }
    
    // Проверить существование игрока по id
    func checkPlayerId(idItem:Int) -> Bool {
        if idItem < 1 { return false }
        let playersCheck =  self._players.contains { $0.id == idItem }
        return playersCheck
    }
    
    // Добавляем новых участников игры
    func addPlayers(players:[Player]) {
        self._players.append(contentsOf: players)
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
    
    // Отсортировать игроков
    func sortPlayers() {
        self._players = self._players.sorted(by: {$0.name < $1.name})
    }
    
    // Обработать конец хода (высчитываем кто убит, кто молчит и тд)
    func handleTurnActions() {
        
        self.turnTextMessage = "" // Сбрасываем сообщения в конце хода
        self.currentTurnDead = [] // Сбрасываем текущего умершего игрока
        
        // Проверим каждого игрока, что с ним произошло за текущий ход
        // (и изменим его статус, а так же сформируем сообщения о том что произошло за ход)
        for player in _players {
            if player.actionCheck(action: ActionType.CitizenKill) {
                player.stateAlive = AliveState.Dead
                self.currentTurnDead.append(player)
                self.turnTextMessage += "Горожане убили \(player.name) (\(player.role.description))\n"
            }
            if player.actionCheck(action: ActionType.MafiaKill) && !player.actionCheck(action: ActionType.Heal) && player.role != Role.Undead {
                player.stateAlive = AliveState.Dead
                self.currentTurnDead.append(player)
                self.turnTextMessage += "Мафия убила \(player.name) (\(player.role.description))\n"
            }
            if player.actionCheck(action: ActionType.ManiacKill) && !player.actionCheck(action: ActionType.Heal) && player.role != Role.Undead {
                player.stateAlive = AliveState.Dead
                self.currentTurnDead.append(player)
                self.turnTextMessage += "Маньяк убил \(player.name) (\(player.role.description))\n"
            }
            if player.actionCheck(action: ActionType.ProstituteSilence) {
                self.turnTextMessage += "Молчит \(player.name)\n"
            }
        }
        if self.turnTextMessage.isEmpty {self.turnTextMessage = "Никто не умер\n"}
        
        // Подсчитываем рейтинг в конце хода
        RatingUtilites.calculateTurnRating(players: &self._players, turnNumber: self.getCurrentTurnNumber(), whoDead: self.currentTurnDead, dayState: self.state)
        
        self.reloadRoles() // Если кто-то умер нужно пересчитать существующие в игре роли

        // Проверяем не закончилась ли игра
        if let whoWin = self.checkEndOfGame() {
            var textOfWin = ""
            switch whoWin {
            case .Citizen:
                textOfWin = "победили Мирные"
            case .Mafia:
                textOfWin = "победила Мафия"
            case .Maniac:
                textOfWin = "победил Маньяк"
            default:
                break
            }
            self.turnTextMessage += "Игра окончена \(textOfWin)\n"
            self.isFinished = true
            
            // Подсчитываем рейтинг конца игры
            RatingUtilites.calculateGameRating(players: &self._players, whoWins:whoWin)
        }
    }
    
    // Проверяем не закончилась ли игра
    func checkEndOfGame() -> Role? {
        var countMafia = 0 // Количество живой мафии в игре
        var countCitizen = 0 // Количество живых мирных
        var countManiac = 0 // Количество живых маньяков
        
        for p in self._players {
            if p.stateAlive == AliveState.Live {
                if p.role == Role.Mafia {
                    countMafia += 1
                } else if p.role == Role.Maniac {
                    countManiac += 1
                } else {
                    countCitizen += 1
                }
            }
        }
        
        if countCitizen > countMafia + countManiac {
            return nil // Игра продолжается горожан больше убивашек
        }
        if countMafia > 1 && countManiac > 1 {
            return nil // Игра продолжается маньяк и мафия еще живы
        }
        if countMafia >= countCitizen && countManiac < 1 {return Role.Mafia} // Мафия победила
        if countManiac >= countCitizen && countMafia < 1 {return Role.Maniac} // Маньяк победил
        if countMafia < 1 && countManiac < 1 {return Role.Citizen} // Мирные победили
        return nil
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
    
    // Сохранить рейтинг
    func saveRating() {
        for p in self._players {
            // Подсчитываем рейтинг игрока текущей законченной игры(не может быть меньше 1)
            var sumRatingOfGame = p.currentRating.reduce(0, { x, y in x + y})
            sumRatingOfGame = sumRatingOfGame < 1 ? 1 : sumRatingOfGame
            
            if p.id > 0 {
                if let findedAccount = self.findAccountById(id: p.id) {
                    findedAccount.name = p.name
                    findedAccount.rating += sumRatingOfGame
                }
            } else {
                if let maxAccount = self.accounts.max(by: { (a1, a2) -> Bool in a1.id < a2.id}) {
                    self.accounts.append(Account(id: maxAccount.id + 1, name: p.name, rating: sumRatingOfGame)!)
                } else {
                    self.accounts.append(Account(id: 1, name: p.name, rating: sumRatingOfGame)!)
                }
            }
        }
        
        self.saveAccounts() // Сохраняем в постоянное хранилище
    }
    
    func findAccountById(id: Int) -> Account? {
        return self.accounts.first(where: { $0.id == id })
    }
    
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
