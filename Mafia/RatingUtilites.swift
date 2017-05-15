//
//  Rating.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 28.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import Foundation

// Класс подсчитывающий рейтинг игроков
class RatingUtilites {
    
    // Подсчитываем рейтинг в конце игры
    static func calculateGameRating(players:inout [Player], whoWins: Role) {
        for p in players {
            // Записываем очки мафии если победили +2
            if whoWins == Role.Mafia && p.role == Role.Mafia {
                p.currentRating.append(2)
            }

            // Записываем очки маньякам если победили +2
            if whoWins == Role.Maniac && p.role == Role.Maniac {
                p.currentRating.append(2)
            }

            // Записываем очки мирным если победили +2
            if whoWins == Role.Citizen && p.role != Role.Mafia {
                p.currentRating.append(2)
            }
        }
    }
    
    // Подсчитываем рейтинг в конце хода
    static func calculateTurnRating(players:inout [Player], turnNumber: Int, whoDead: [Player]?, dayState: DayNightState) {
        
        // Стартовые значения начисляемых очков
        var pointForSherif = 0
        var pointForDoctor = 0
        var pointForManiac = 0
        var pointForDon = 0
        //var pointForProstitute = 0 временно убрали очки за затыкание(т.к. теперь заьтыкают и маньяк и проститутка)
        
        // Стартовые значения живых игроков
        var sherif:Player? = nil
        var doctor:Player? = nil
        //var prostitute:Player? = nil временно убрали очки за затыкание(т.к. теперь заьтыкают и маньяк и проститутка)
        var don:Player? = nil
        var maniac:Player? = nil

        // Вас убили днем -1
        if (whoDead?.count)! > 0 && dayState == DayNightState.Day {
            for whoDeadPerson in whoDead! {
                whoDeadPerson.currentRating.append(-1)

                // Бессмертный умер днем еще -1
                if whoDeadPerson.role == Role.Undead {whoDeadPerson.currentRating.append(-1)}
            }
        }
        
        for p in players {
            if p.role == Role.Sherif && p.stateAlive == AliveState.Live {
                sherif = p // запомнили живого комиссара
            }

            if p.role == Role.Don && p.stateAlive == AliveState.Live {
                don = p // запомнили живого дона
            }

            if p.role == Role.Doctor && p.stateAlive == AliveState.Live {
                doctor = p // запомнили живого доктора
            }
            
            if p.role == Role.Maniac && p.stateAlive == AliveState.Live {
                maniac = p // запомнили живого маньяка
            }
            
            //if p.role == Role.Prostitute && p.stateAlive == AliveState.Live {
            //    prostitute = p // запомнили живую путану
            //}
            
            // Коммисар угадал с проверкой +2 живому комиссару -1 кого проверили(мафии)
            if p.actionCheck(action: ActionType.SherifCheck) && p.role == Role.Mafia {
                pointForSherif = 2
                p.currentRating.append(-1)
            }

            // Дон мафии угадал с проверкой коммисара +2 живому дону -1 кого проверили(коммисару)
            if p.actionCheck(action: ActionType.DonCheck) && p.role == Role.Sherif {
                pointForDon = 2
                p.currentRating.append(-1)
            }
            
            // Доктор вылечил, доктору +3
            if p.actionCheck(action: ActionType.Heal) && p.actionCheck(action: ActionType.MafiaKill) && p.actionCheck(action: ActionType.ManiacKill) {
                pointForDoctor = 3
            }

            if (whoDead?.count)! > 0 {
                for whoDeadPerson in whoDead! {
                    
                    // Убили мирного или маньяка всей живой мафии днем +1
                    if whoDeadPerson.role != Role.Mafia && p.role == Role.Mafia && p.stateAlive == AliveState.Live && dayState == DayNightState.Day {
                        p.currentRating.append(1)
                    }
                    
                    // Убили мафию всем живым мирным кроме маньяка днем +1
                    if whoDeadPerson.role == Role.Mafia && p.role != Role.Mafia && p.role != Role.Maniac && p.stateAlive == AliveState.Live && dayState == DayNightState.Day {
                        p.currentRating.append(1)
                    }

                    // Маньяк ночью убил кого угодно +2 маньяку
                    if whoDeadPerson.actionCheck(action: ActionType.ManiacKill) && dayState == DayNightState.Night {
                        pointForManiac = 2
                    }

                }
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
        
        // Маньяк убил (кого угодно)
        if pointForManiac != 0 && maniac != nil {
            maniac?.currentRating.append(pointForManiac)
        }

        // Дон проверил коммисара
        if pointForDon != 0 && don != nil {
            don?.currentRating.append(pointForDon)
        }

    }
}
