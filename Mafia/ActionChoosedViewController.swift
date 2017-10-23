//
//  ActionChoosedViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 12.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class ActionChoosedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var actionPlayersTable: UITableView!
    @IBOutlet weak var actionLabel: UILabel!
    
    // MARK: - События контроллера
    
    var choosedAction: ActionType?
    var actionPlayers: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Определяем данные для заполнения таблицы
        actionPlayers = game.getPlayersForAction(action: choosedAction!)
        
        // Делаем навигационную панель прозрачной
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        actionLabel.text = "Кого " + (choosedAction?.description)! + "?"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Методы управления таблицей участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return actionPlayers.count
    }
    
    // Расстояние между ячейками(секциями)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // Описываем состояние заголовка секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Удаляем для текущих пользователей все действия подобного типа
        for p in self.actionPlayers {
            p.removeAction(action: choosedAction!, turn: game.getCurrentTurnNumber())
        }
        
        // А теперь для выбранного пользователя сохраняем имеющееся действие
        let selectedPlayer = actionPlayers[indexPath.section]
        selectedPlayer.addAction(action: choosedAction!, turn: game.getCurrentTurnNumber())
        
        
        self.performSegue(withIdentifier: "ChoosedPlayer", sender: self)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "ActionPlayersTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ActionPlayersTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ActionPlayersTableViewCell.")
        }
        
        // Определяем дынные для заполнения ячейки таблицы
        let player = actionPlayers[indexPath.section]
        
        // Визуально оформляем ячейку
        cell.layer.cornerRadius = 0
        let evenColor = UIColor(rgb: 0xB88E8E, alpha: 0.1).cgColor
        let oddColor = UIColor(rgb: 0xB88E8E, alpha: 0).cgColor
        
        // Разноцвет между соседними ячейками
        if indexPath.section % 2 == 0 {
            cell.layer.backgroundColor = oddColor
        } else {
            cell.layer.backgroundColor = evenColor
        }
        
        // Заполняем рейтинг ячейки
        let sum = player.currentRating.reduce(0, { x, y in x + y})
        cell.ratingLabel.text = "\(sum < 1 ? 1 : sum)"
        
        // Заполним данные для кнопок
        cell.numberLabel.text = "\(indexPath.section + 1)."
        cell.nameLabel.text = player.name
        if player.actionCheck(action: choosedAction!) {
            cell.choosedImage.isHidden = false
            cell.linkLabel.isHidden = true
        } else {
            cell.choosedImage.isHidden = true
            cell.linkLabel.isHidden = false
        }
        
        // Меняем иконку текущей роли игрока
        switch player.role {
        case .Citizen:
            cell.roleImage.image = UIImage(named: "Citizen")
        case .Doctor:
            cell.roleImage.image = UIImage(named: "Doctor")
        case .Mafia:
            cell.roleImage.image = UIImage(named: "Mafia")
        case .Don:
            cell.roleImage.image = UIImage(named: "Don")
        case .Maniac:
            cell.roleImage.image = UIImage(named: "Maniac")
        case .Prostitute:
            cell.roleImage.image = UIImage(named: "Putana")
        case .Sherif:
            cell.roleImage.image = UIImage(named: "Sheriff")
        case .Undead:
            cell.roleImage.image = UIImage(named: "Undead")
        case .Yacuza:
            cell.roleImage.image = UIImage(named: "Yakudza")
        case .Lawyer:
            cell.roleImage.image = UIImage(named: "Lawyer")
        }
        
        return cell
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Обработка действий пользователя
    
    @IBAction func backButtonPush(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CancelChoose", sender: self)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
