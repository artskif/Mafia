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
    
    // MARK: - Поля класса
    
    private var _players:[Player]
    
    // MARK: - Инициализаторы класса
    
    init (players:[Player]) {
        self._players = players
    }
    
    // Подсчитываем рейтинг в конце игры
    func calculateGameRating() {
        
    }
    
    // Подсчитываем рейтинг в конце хода
    func calculateTurnRating(turnNumber: Int, whoDead: Player?, dayState: DayNightState) {
        
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
        }
        
        // Бессмертный умер днем -2
        if whoDead != nil && dayState == DayNightState.Day && whoDead?.role == Role.Undead {whoDead!.currentRating.append(-2)}
        
        for p in self._players {
            if p.role == Role.Sherif && p.stateAlive == AliveState.Live {
                sherif = p // запомнили живого комиссара
            }
            
            if p.role == Role.Sherif && p.stateAlive == AliveState.Live {
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
                // Убили мирного всей живой мафии +1
                if whoDead?.role != Role.Mafia && p.role == Role.Mafia && p.stateAlive == AliveState.Live {
                    p.currentRating.append(1)
                }
                
                // Убили мафию всем живым мирным +1
                if whoDead?.role == Role.Mafia && p.role != Role.Mafia && p.stateAlive == AliveState.Live {
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
