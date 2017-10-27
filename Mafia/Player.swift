//
//  Player.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 13.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log

// класс описывающий одного игрока приложения Мафия
class Player {
    var name:String // Имя
    var rating:Int16 // Сумма очков рейтинга
    var id:Int16 // Id
    var role:Role // Роль в игре
    var isWin:Bool // Флажок выиграл игрок или нет
    var turnsOfLife:Int16 // Количество ходов которое игрок прожил (Ночь 1 ход и День тоже 1 ход)
    var stateAlive:AliveState // Живой игрок или мертвый
    var currentRating:[Int] // Рейтинг текущего хода
    // Конструкция вида [Действие(проверен, убит, исцелен), На каких ходах(1 - да, 3 - нет, 6 - да)] - многомерный массив
    var actions:Dictionary<ActionType, Dictionary<Int,Bool>>
    
    init() {
        self.role = Role.Citizen
        self.currentRating = [1]
        self.stateAlive = AliveState.Live
        self.turnsOfLife = 1
        self.actions = [:]
        self.id = 0
        self.rating = 0
        self.name = ""
        self.isWin = false
    }
    
    convenience init?(name:String){
        self.init()
        self.name = name
    }
    
    convenience init?(id: Int16, name:String, rating: Int16){
        self.init()
        self.id = id
        self.rating = rating
        self.name = name
    }
    
    convenience init?(baseObject: UserAccount) {
        self.init(id: baseObject.id, name: baseObject.name!, rating: baseObject.rating)
    }
    
    // MARK: - Методы управления Действиями(Action)
    
    // Добавляем новое выполненное действие для пользователя
    func addAction(action: ActionType, turn: Int) {
        self.actions[action] = [turn:true]
    }
    
    // Удаляем действие пользователя для текущего хода
    func removeAction(action: ActionType, turn: Int) {
        self.actions[action] = [turn:false]
    }
    
    // Переключаем новое выполненное действие для пользователя
    func toggleAction(action: ActionType, turn: Int) {
        if self.actionCheck(action: action) {
            self.removeAction(action: action, turn: turn)
        } else {
            self.addAction(action: action, turn: turn)
        }
    }
    
    // Проверяем выполнено ли указанное действие для пользователя на текущем ходу
    func actionCheck(action: ActionType) -> Bool{
        if self.actions[action] != nil {
            if self.actions[action]![game.getCurrentTurnNumber()] != nil {
                return self.actions[action]![game.getCurrentTurnNumber()]!
            }
        }
        return false
    }
}
