//
//  Rating.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 28.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import Foundation

// Класс подсчитывающий рейтинг игроков
class Rating {
    
    // Подсчитываем рейтинг в конце игры
    static func calculateGameRating(players:inout [Player], whoWins: Role) {
        for p in players {
            // Записываем очки мафии если победили +2
            if whoWins == Role.Mafia && p.role == Role.Mafia {
                p.currentRating.append(2)
            }

            // Записываем очки мирным если победили +2
            if whoWins == Role.Citizen && p.role != Role.Mafia {
                p.currentRating.append(2)
            }
        }
    }
    
    // Подсчитываем рейтинг в конце хода
    static func calculateTurnRating(players:inout [Player], turnNumber: Int, whoDead: Player?, dayState: DayNightState) {
        
        // Стартовые значения начисляемых очков
        var pointForSherif = 0
        var pointForDoctor = 0
        var pointForProstitute = 0
        
        // Стартовые значения живых игроков
        var sherif:Player? = nil
        var doctor:Player? = nil
        var prostitute:Player? = nil

        // Вас убили днем -1
        if whoDead != nil && dayState == DayNightState.Day {
            whoDead!.currentRating.append(-1)
            
            // Бессмертный умер днем еще -1
            if whoDead?.role == Role.Undead {whoDead!.currentRating.append(-1)}
        }
        
        for p in players {
            if p.role == Role.Sherif && p.stateAlive == AliveState.Live {
                sherif = p // запомнили живого комиссара
            }
            
            if p.role == Role.Doctor && p.stateAlive == AliveState.Live {
                doctor = p // запомнили живого доктора
            }
            
            if p.role == Role.Prostitute && p.stateAlive == AliveState.Live {
                prostitute = p // запомнили живую путану
            }
            
            // Коммисар угадал с проверкой +3 живому комиссару -1 кого проверили(мафии)
            if p.actionCheck(action: ActionType.SherifCheck) && p.role == Role.Mafia {
                pointForSherif = 3
                p.currentRating.append(-1)
            }
            
            if whoDead != nil {
                // Убили мирного всей живой мафии днем +1
                if whoDead?.role != Role.Mafia && p.role == Role.Mafia && p.stateAlive == AliveState.Live && dayState == DayNightState.Day {
                    p.currentRating.append(1)
                }
                
                // Убили мафию всем живым мирным днем +1
                if whoDead?.role == Role.Mafia && p.role != Role.Mafia && p.stateAlive == AliveState.Live && dayState == DayNightState.Day {
                    p.currentRating.append(1)
                }
            }
            
            // Доктор вылечил, доктору +3
            if p.actionCheck(action: ActionType.Heal) && p.actionCheck(action: ActionType.MafiaKill) {
                pointForDoctor = 3
            }
            
            // Путана заткнула мафию +1
            if p.actionCheck(action: ActionType.ProstituteSilence) && p.role == Role.Mafia {
                pointForProstitute = 1
            }
        }
        
        // Комисар угадал с проверкой
        if pointForSherif != 0 && sherif != nil {
            sherif?.currentRating.append(pointForSherif)
        }
        
        // Доктор вылечил
        if pointForDoctor != 0 && doctor != nil {
            doctor?.currentRating.append(pointForDoctor)
        }
        
        // Путана заткнула мафию
        if pointForProstitute != 0 && prostitute != nil {
            prostitute?.currentRating.append(pointForProstitute)
        }
    }
}
