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

enum Role:String {
    case Mafia = "Мафия"
    case Citizen = "Мирный"
    case Sherif = "Коммисар"
    case Doctor = "Доктор"
    case Prostitute = "Проститутка"
    case Undead = "Бессмертный"
}

enum ActionType {
    case MafiaKill
    case SherifCheck
    case Heal
    case CitizenKill
}
