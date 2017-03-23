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
    
    // MARK: - Элементы управления страницей
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var dayNightButton: UIBarButtonItem!
    @IBOutlet weak var endOfTheGameButton: UIBarButtonItem!
    
    // MARK: - Методы инициализации таблицы участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players.count
    }
    
    // Обрабатываем внешний вид и содержимое ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "PlayerTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? PlayerTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlayerTableViewCell.")
        }
        
        // Определяем дынные для заполнения ячейки таблицы
        let player = game.players[indexPath.row]
        
        cell.killButton.tag = indexPath.row
        cell.nameLabel.text = player.name
        
        return cell
    }
    
    // Обрабатываем события редактирования над таблицей участников
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем элемент массива данных участников игры
            game.players.remove(at: indexPath.row)
            savePlayers()
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
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load any saved players, otherwise load sample data.
        if let savedPlayers = loadPlayers() {
            game.players = savedPlayers
        } else {
            // Load the sample data.
            loadSamplePlayers()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Метод вызываемый непосредственно перед навигацией по контроллерам
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
    
    //MARK: - Обработка действий пользователя
    
    // Нажали кнопку Save на странице добавления пользователя в игру
    @IBAction func unwindToPlayerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddController, let player = sourceViewController.player {
            
            if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
                // Update an existing meal.
                game.players[selectedIndexPath.row] = player
                playersTableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: game.players.count, section: 0)
                
                game.players.append(player)
                playersTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            savePlayers()
        }               
    }
    
    // Нажали кнопку Cancel на странице добавления пользователя в игру
    @IBAction func unwindCancelToPlayerList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
            // Deselect a selected row on cancel.
            playersTableView.deselectRow(at: selectedIndexPath, animated: false)
        }
    }
    
    // Нажали кнопку "Мафия убивает" в таблице
    @IBAction func pushMafiaKill(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        game.players.remove(at: sender.tag)
        savePlayers()
        playersTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // Нажали кнопку "Смена дня и ночи" в панели инструментов
    @IBAction func tapDayNightButton(_ sender: UIBarButtonItem) {
    }
    
    // Нажали кнопку "Закончить игру" в панели инструментов
    @IBAction func tapEndOfTheGameButton(_ sender: UIBarButtonItem) {
    }
    
    // MARK: - Управление данными контроллера
    
    // Загрузка тестовых данных таблицы участников игры
    private func loadSamplePlayers() {
        guard let player1 = Player(name: "Игрок 1")
        else {
            fatalError("Unable to instantiate player1")
        }
        
        guard let player2 = Player(name: "Игрок 2")
            else {
                fatalError("Unable to instantiate player2")
        }
        
        guard let player3 = Player(name: "Игрок 3")
            else {
                fatalError("Unable to instantiate player3")
        }
        
        game.players += [player1, player2, player3]
    }
    
    // Сохранение участников игры в постоянное хранилище телефона
    private func savePlayers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(game.players, toFile: Account.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Players successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save players...", log: OSLog.default, type: .error)
        }
    }
    
    // Выгрузка участников игры из хранилища телефона
    private func loadPlayers() -> [Player]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Player.ArchiveURL.path) as? [Player]
    }
}
