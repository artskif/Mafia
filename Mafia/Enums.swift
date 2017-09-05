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
    case Yacuza = 8
    case Lawyer = 9
    
    static var count:Int {return Role.Lawyer.hashValue + 1}
    
    var description: String {
        switch self {
        case .Citizen:
            return "Не имеет специальных возможностей, активно проявляет гражданскую позицию днем"
        case .Doctor:
            return "Может лечить одного из игроков, а так же лечит себя, но не более 2 раз за игру"
        case .Mafia:
            return "Часть преступной группировки. Ночью со своими сообщниками убивает горожан"
        case .Prostitute:
            return "Ночью дарит наслаждение одному из игроков, так что игрок днем не может говорить"
        case .Sherif:
            return "Каждую ночь проверяет одного из игроков, пытаясь обнаружить мафию"
        case .Undead:
            return "Бессмертного нельзя убить ночью, можно спать спокойно"
        case .Don:
            return "Дон мафии решает, кто умрет ночью. Так же ночью пытается найти комиссара"
        case .Maniac:
            return "Безумен, ночью может заткнуть(днем молчит) или убить одного из игроков"
        case .Yacuza:
            return "Вы воюете со всеми. Ваша задача истребить всех: мирных жителей, мафию, маньяка"
        case .Lawyer:
            return "Ночью ты обеспечиваешь одному из игроков алиби. За него не могут голосовать днем"
        }
    }
    
    var title: String {
        switch self {
        case .Citizen:
            return "Мирный"
        case .Doctor:
            return "Доктор"
        case .Mafia:
            return "Мафия"
        case .Prostitute:
            return "Путана"
        case .Sherif:
            return "Комиссар"
        case .Undead:
            return "Бессмертный"
        case .Don:
            return "Дон мафии"
        case .Maniac:
            return "Маньяк"
        case .Yacuza:
            return "Якудза"
        case .Lawyer:
            return "Адвокат"
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
    case YacuzaKill
    case LawyerGet
}
