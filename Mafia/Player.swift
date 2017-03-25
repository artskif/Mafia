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
class Player: Account {
    var role:Role
    var stateAlive:AliveState
    var currentRating:[Int]
    // TODO: Возможны варианты совершенствования конструкции
    // Конструкция вида [Действие(проверен, убит, исцелен): На каких хода(1 - да, 3 - нет, 6 - да)] - многомерный массив
    var actions:Dictionary<ActionType, Dictionary<Int,Bool>>
    
    init?(name:String){
        self.role = Role.Citizen
        self.currentRating = []
        self.stateAlive = AliveState.Live
        self.actions = [:]
        
        super.init(name: name)
    }
    
    override init?(name:String, rating: Int){
        self.role = Role.Citizen
        self.currentRating = []
        self.stateAlive = AliveState.Live
        self.actions = [:]
        
        super.init(name: name, rating: rating)
    }
    
    init?(baseObject: Account) {
        self.role = Role.Citizen
        self.currentRating = []
        self.stateAlive = AliveState.Live
        self.actions = [:]
        
        super.init(name: baseObject.name, rating: baseObject.rating)
    }
    
    // здесь мы сохраняем данные(в хранилище сотового телефона) для дальнейшего использования при закрытии приложения
    // данные сохраняются при помощи библиотеки NSCoding
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(rating, forKey: "rating")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
            os_log("Unable to decode the name for a Player object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let rating = aDecoder.decodeInteger(forKey: "rating")
        
        self.init(name: name, rating: rating)
    }
}
