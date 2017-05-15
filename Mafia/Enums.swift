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
    case Citizen = 0
    case Mafia = 1
    case Sherif = 2
    case Doctor = 3
    case Prostitute = 4
    case Undead = 5
    case Don = 6
    case Maniac = 7
    
    static var count:Int {return Role.Maniac.hashValue + 1}
    
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
            return "Комиссар"
        case .Undead:
            return "Бессмертный"
        case .Don:
            return "Дон мафии"
        case .Maniac:
            return "Маньяк"
        }
    }
}

enum ActionType {
    case MafiaKill
    case SherifCheck
    case Heal
    case CitizenKill
    case ProstituteSilence
    case ManiacKill
    case DonCheck
}
