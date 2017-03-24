//
//  Enums.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 22.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//


enum DayNightState {
    case Day
    case Night
}

enum AliveState {
    case Live
    case Dead
}

enum Role:Int, CustomStringConvertible {
    case Mafia = 0
    case Citizen = 1
    case Sherif = 2
    case Doctor = 3
    case Prostitute = 4
    case Undead = 5
    
    static var count:Int {return Role.Undead.hashValue + 1}
    
    var description: String {
        switch self {
        case .Citizen:
            return "Мирный"
        case .Doctor:
            return "Доктор"
        case .Mafia:
            return "Мафия"
        case .Prostitute:
            return "Проститутка"
        case .Sherif:
            return "Коммисар"
        case .Undead:
            return "Бессмертный"
        default:
            return ""
        }
    }
}

enum ActionType {
    case MafiaKill
    case SherifCheck
    case Heal
    case CitizenKill
}
