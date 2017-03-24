//
//  PlayController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 11.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log

class PlayController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var dayNightButton: UIBarButtonItem!
    @IBOutlet weak var endOfTheGameButton: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Метод вызываемый непосредственно перед навигацией по контроллерам
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // обработка поведения нового контроллера в зависимости от того каким переходом(segue) мы пользуемся
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new player.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let playerDetailViewController = segue.destination as? AddController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPlayerCell = sender as? PlayerTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = playersTableView.indexPath(for: selectedPlayerCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPlayer = game.players[indexPath.row]
            playerDetailViewController.player = selectedPlayer
        default:
            break
        }
    }
    
    // MARK: - Методы инициализации таблицы участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players.count
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "PlayerTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? PlayerTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlayerTableViewCell.")
        }
        
        // Определяем дынные для заполнения ячейки таблицы
        let player = game.players[indexPath.row]
        
        cell.killButton.tag = indexPath.row
        cell.nameLabel.text = player.name
        cell.roleLabel.text = player.role.rawValue
        if game.state == DayNightState.Day{
            cell.healButton.isHidden = true
            cell.checkButton.isHidden = true
            cell.silenceButton.isHidden = true
        } else {
            cell.healButton.isHidden = false
            cell.checkButton.isHidden = false
            cell.silenceButton.isHidden = false
        }
        
        return cell
    }
    
    // Обрабатываем события редактирования над таблицей участников
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем элемент массива данных участников игры
            game.players.remove(at: indexPath.row)
            playersTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - Обработка действий пользователя
    
    // Нажали кнопку Save на странице добавления пользователя в игру
    @IBAction func unwindToPlayerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddController, let player = sourceViewController.player {
            
            if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
                // Обновляем пользователя в таблице
                game.players[selectedIndexPath.row] = player
                playersTableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Добавляем нового пользователя в таблицу
                let newIndexPath = IndexPath(row: game.players.count, section: 0)
                
                game.players.append(player)
                playersTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }               
    }
    
    // Нажали кнопку Cancel на странице добавления пользователя в игру
    @IBAction func unwindCancelToPlayerList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
            // Сбрасываем выбранную ячейку в таблице при нажатии на кнопку Cancel
            playersTableView.deselectRow(at: selectedIndexPath, animated: false)
        }
    }
    
    // Нажали кнопку "Мафия убивает" в таблице
    @IBAction func pushMafiaKill(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        game.players.remove(at: sender.tag)
        playersTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // Нажали кнопку "Выбор роли" в таблице
    @IBAction func pushSetRole(_ sender: UIButton) {
    }
    
    // Нажали кнопку "Смена дня и ночи" в панели инструментов
    @IBAction func tapDayNightButton(_ sender: UIBarButtonItem) {
        game.startNewTurn()

        if game.state == DayNightState.Night {
            mainView.backgroundColor = UIColor.white
            game.state = DayNightState.Day
        } else {
            mainView.backgroundColor = UIColor.black
            game.state = DayNightState.Night
        }
        playersTableView.reloadData()
    }
    
    // Нажали кнопку "Закончить игру" в панели инструментов
    @IBAction func tapEndOfTheGameButton(_ sender: UIBarButtonItem) {
    }
}
