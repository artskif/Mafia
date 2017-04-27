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
    @IBOutlet weak var addNewPlayerButton: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Начинаем новую игру
        game = Game()
        
        // Сортируем участников игры
        game.sortPlayers()
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
                fatalError("Unexpected sender")
            }
            
            guard let indexPath = playersTableView.indexPath(for: selectedPlayerCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPlayer = game.getPlayer(at: indexPath.row)
            playerDetailViewController.editPlayer = selectedPlayer
        default:
            break
        }
    }
    
    // MARK: - Методы инициализации таблицы участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.countPlayers()
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "PlayerTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? PlayerTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlayerTableViewCell.")
        }
        
        // Определяем дынные для заполнения ячейки таблицы
        let player = game.getPlayer(at: indexPath.row)
        
        // Заполним данные для кнопок
        cell.killButton.tag = indexPath.row
        cell.healButton.tag = indexPath.row
        cell.checkButton.tag = indexPath.row
        cell.silenceButton.tag = indexPath.row
        cell.nameLabel.text = player.name
        cell.roleLabel.text = player.role.description
        cell.numberLaber.text = "\(indexPath.row + 1)"
        
        // Ячейка мертвого пользователя
        if player.stateAlive == AliveState.Dead {
            cell.backgroundColor = UIColor.darkGray
            cell.isUserInteractionEnabled = false

            cell.healButton.isHidden = true
            cell.checkButton.isHidden = true
            cell.silenceButton.isHidden = true
            cell.killButton.isHidden = true
            
            if !cell.roleLabel.text!.hasSuffix("Мертв") {
                cell.roleLabel.text = cell.roleLabel.text! + " - Мертв"
            }
            
            return cell
        } else {
            cell.backgroundColor = UIColor.clear
            cell.isUserInteractionEnabled = true
        }
        
        if game.state == DayNightState.Day { // Что показываем в ячейке Днем
            cell.healButton.isHidden = true
            cell.checkButton.isHidden = true
            cell.silenceButton.isHidden = true
            cell.killButton.isHidden = game.roles[Role.Mafia.rawValue] == nil
            
            // Отрисовываем нажатие кнопки "Убить"
            if player.actionCheck(action: ActionType.CitizenKill) {
                cell.killButton.alpha = 0.5
            } else {
                cell.killButton.alpha = 1
            }
        } else { // А тут далее то что у нас показывается в ячейке ночью
            // Отрисовываем нажатие кнопки "Полечить"
            if player.actionCheck(action: ActionType.Heal) {
                cell.healButton.alpha = 0.5
            } else {
                cell.healButton.alpha = 1
            }
            
            // Отрисовываем нажатие кнопки "Полечить"
            if player.actionCheck(action: ActionType.MafiaKill) {
                cell.killButton.alpha = 0.5
            } else {
                cell.killButton.alpha = 1
            }
            
            // Отрисовываем нажатие кнопки "Заткнули"
            if player.actionCheck(action: ActionType.ProstituteSilence) {
                cell.silenceButton.alpha = 0.5
            } else {
                cell.silenceButton.alpha = 1
            }
            
            // Отрисовываем нажатие кнопки "Проверили"
            if player.actionCheck(action: ActionType.SherifCheck) {
                cell.checkButton.alpha = 0.5
            } else {
                cell.checkButton.alpha = 1
            }
            
            cell.healButton.isHidden = game.roles[Role.Doctor.rawValue] == nil
            cell.checkButton.isHidden = game.roles[Role.Sherif.rawValue] == nil || player.role == Role.Sherif
            cell.silenceButton.isHidden = game.roles[Role.Prostitute.rawValue] == nil
            cell.killButton.isHidden = game.roles[Role.Mafia.rawValue] == nil || player.role == Role.Mafia
        }

        return cell
    }
    
    // Обрабатываем события редактирования над таблицей участников
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем элемент массива данных участников игры
            game.removePlayer(at: indexPath.row)
            playersTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !game.isStarted
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - Обработка действий пользователя
    
    // Нажали кнопку Save на странице добавления пользователя в игру
    @IBAction func unwindToPlayerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddController{
            
            if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
                // Обновляем пользователя в таблице
                if let editPlayer = sourceViewController.editPlayer {
                    game.setPlayer(at: selectedIndexPath.row, element: editPlayer)
                    playersTableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
            }
            else {
                // Добавляем нового пользователя в таблицу
                let newPlayers = sourceViewController.newPlayers
                
                if newPlayers.count > 0 {
                    game.addPlayers(players: newPlayers)
                }
            }
            
            // Сортируем участников игры
            game.sortPlayers()
            
            playersTableView.reloadData()
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
        // Если днем убили то горожане(с мафией) если ночью то мафия
        let actionType = game.state == DayNightState.Day ? ActionType.CitizenKill : ActionType.MafiaKill
        
        self.createAction(newAction: actionType, cellRow: sender.tag)

        if !game.isStarted {self.startNewGame()} // Стартуем!
    }
    
    // Нажали кнопку "Доктор вылечил" в таблице
    @IBAction func pushDoctorHeal(_ sender: UIButton) {
        self.createAction(newAction: ActionType.Heal, cellRow: sender.tag, ifState: DayNightState.Night)
    }
    
    // Нажали кнопку "Комисар проверил" в таблице
    @IBAction func pushSherifCheck(_ sender: UIButton) {
        self.createAction(newAction: ActionType.SherifCheck, cellRow: sender.tag, ifState: DayNightState.Night)
    }
    
    // Нажали кнопку "Проститутка заткнула" в таблице
    @IBAction func pushProstituteSilence(_ sender: UIButton) {
        self.createAction(newAction: ActionType.ProstituteSilence, cellRow: sender.tag, ifState: DayNightState.Night)
    }
    
    // Нажали кнопку "Смена дня и ночи" в панели инструментов
    @IBAction func tapDayNightButton(_ sender: UIBarButtonItem) {
        let popOverVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupStoriboardID") as! PopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        game.handleTurnActions() // Обрабатываем событие окончания хода
        
        if game.isFinished {self.dayNightButton.isEnabled = false} // Если игра закончилась нет смысла начинать новый ход
        
        popOverVC.textMessageLabel.text = game.turnTextMessage // Показываем игровые собщения окончания хода
        
        // Меняем интерфейс приложения для обозначения смены дня и ночи
        if game.state == DayNightState.Night {
            mainView.backgroundColor = UIColor.white
        } else {
            mainView.backgroundColor = UIColor.black
        }
        game.startNewTurn() // Начинаем новый ход
        
        playersTableView.reloadData() // Обновляем таблицу
        
        if !game.isStarted {self.startNewGame()} // Стартуем игру!
    	}
    
    // Нажали кнопку "Закончить игру" в панели инструментов
    @IBAction func tapEndOfTheGameButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Завершение игры", message: "Хотите сохранить рейтинг?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: { (action) in
            self.finishCurrentGame(saveRating: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.default, handler: { (action) in
            self.finishCurrentGame(saveRating: false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Методы управления страницей
    
    // Начали новую игру(сделали первый ход)
    func startNewGame(){
        game.isStarted = true
        addNewPlayerButton.isEnabled = false
        playersTableView.isEditing = false
        playersTableView.reloadData()
    }
    
    // Завершаем текущую игру
    func finishCurrentGame(saveRating: Bool) {
        self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
        
        if saveRating {game.saveRating()}
        
        let isPresentingInAddPlayerMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPlayerMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The PlayController is not inside a navigation controller.")
        }

    }
    
    // Выполняем новое действие над пользователем (убить, вылечить, проверить и тд.)
    func createAction(newAction: ActionType, cellRow: Int, ifState: DayNightState? = nil) {
        guard ifState == nil || game.state == ifState else {
            os_log("Bad state for create action", log: OSLog.default, type: .error)
            return
        }
        
        let indexPath = IndexPath(item: cellRow, section: 0) // Индекс хода
        let actionPlayer = game.getPlayer(at: indexPath.row) // Над кем(игрок) действие
        
        actionPlayer.toggleAction(action: newAction, turn: game.getCurrentTurnNumber())
        
        playersTableView.reloadData()
    }
}
