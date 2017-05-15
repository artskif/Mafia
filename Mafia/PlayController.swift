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
        
        // Регистрируем собственную ячейку(cell) в таблице
        let nib = UINib(nibName: "PlayTableViewCell", bundle: nil)
        playersTableView.register(nib, forCellReuseIdentifier: "PlayTableViewCell")
        
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
            
            if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
                let selectedPlayer = game.getPlayer(at: selectedIndexPath.section)
                playerDetailViewController.editPlayer = selectedPlayer
            }
            
        default:
            break
        }
    }
    
    // MARK: - Методы инициализации таблицы участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return game.countPlayers()
    }
    
    // Расстояние между ячейками(секциями)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Описываем состояние заголовка секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "PlayTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? PlayTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlayTableViewCell.")
        }
        
        // Вешаем обработчики событий на кнопки
        cell.killButton.addTarget(self, action: #selector(pushMafiaKill), for: UIControlEvents.touchUpInside)
        cell.healButton.addTarget(self, action: #selector(pushDoctorHeal), for: UIControlEvents.touchUpInside)
        cell.checkButton.addTarget(self, action: #selector(pushSherifCheck), for: UIControlEvents.touchUpInside)
        cell.silenceButton.addTarget(self, action: #selector(pushProstituteSilence), for: UIControlEvents.touchUpInside)
        cell.donmaffiaButton.addTarget(self, action: #selector(pushDonMaffia), for: UIControlEvents.touchUpInside)
        cell.maniacButton.addTarget(self, action: #selector(pushManiacKill), for: UIControlEvents.touchUpInside)
        
        
        // Определяем дынные для заполнения ячейки таблицы
        let player = game.getPlayer(at: indexPath.section)
        
        // Заполним данные для кнопок
        cell.killButton.tag = indexPath.section
        cell.healButton.tag = indexPath.section
        cell.checkButton.tag = indexPath.section
        cell.silenceButton.tag = indexPath.section
        cell.donmaffiaButton.tag = indexPath.section
        cell.maniacButton.tag = indexPath.section
        cell.nameLabel.text = player.name
        cell.numberLaber.text = "\(indexPath.section + 1)"
        cell.killImage.isHidden = true
        
        // Меняем иконку текущей роли игрока
        switch player.role {
        case .Citizen:
            cell.roleImage.image = UIImage(named: "Role icon sitizen")
        case .Doctor:
            cell.roleImage.image = UIImage(named: "Role icon medic")
        case .Mafia:
            cell.roleImage.image = UIImage(named: "Role icon mafia")
        case .Don:
            cell.roleImage.image = UIImage(named: "Role icon don maffia")
        case .Maniac:
            cell.roleImage.image = UIImage(named: "Role icon maniac")
        case .Prostitute:
            cell.roleImage.image = UIImage(named: "Role icon putana")
        case .Sherif:
            cell.roleImage.image = UIImage(named: "Role icon sheriff")
        case .Undead:
            cell.roleImage.image = UIImage(named: "Role icon undead")
        }
                
        // Ячейка мертвого пользователя
        if player.stateAlive == AliveState.Dead {
            cell.killImage.isHidden = false
            cell.isUserInteractionEnabled = false

            cell.healButton.isHidden = true
            cell.checkButton.isHidden = true
            cell.silenceButton.isHidden = true
            cell.killButton.isHidden = true
            cell.maniacButton.isHidden = true
            cell.donmaffiaButton.isHidden = true
            
            return cell
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        if game.state == DayNightState.Day { // Что показываем в ячейке Днем
            cell.healButton.isHidden = true
            cell.checkButton.isHidden = true
            cell.silenceButton.isHidden = true
            cell.donmaffiaButton.isHidden = true
            cell.maniacButton.isHidden = true
            cell.killButton.isHidden = game.roles[Role.Mafia.rawValue] == nil
            
            // Отрисовываем нажатие кнопки "Убить"
            if player.actionCheck(action: ActionType.CitizenKill) {
                cell.killButton.alpha = 1
            } else {
                cell.killButton.alpha = 0.3
            }
        } else { // А тут далее то что у нас показывается в ячейке ночью
            // Отрисовываем нажатие кнопки "Полечить"
            if player.actionCheck(action: ActionType.Heal) {
                cell.healButton.alpha = 1
            } else {
                cell.healButton.alpha = 0.3
            }
            
            // Отрисовываем нажатие кнопки "Убить"
            if player.actionCheck(action: ActionType.MafiaKill) {
                cell.killButton.alpha = 1
            } else {
                cell.killButton.alpha = 0.3
            }
            
            // Отрисовываем нажатие кнопки "Заткнули"
            if player.actionCheck(action: ActionType.ProstituteSilence) {
                cell.silenceButton.alpha = 1
            } else {
                cell.silenceButton.alpha = 0.3
            }
            
            // Отрисовываем нажатие кнопки "Проверили Комиссаром"
            if player.actionCheck(action: ActionType.SherifCheck) {
                cell.checkButton.alpha = 1
            } else {
                cell.checkButton.alpha = 0.3
            }

            // Отрисовываем нажатие кнопки "Убил маньяк"
            if player.actionCheck(action: ActionType.ManiacKill) {
                cell.maniacButton.alpha = 1
            } else {
                cell.maniacButton.alpha = 0.3
            }

            // Отрисовываем нажатие кнопки "Проверили Доном"
            if player.actionCheck(action: ActionType.DonCheck) {
                cell.donmaffiaButton.alpha = 1
            } else {
                cell.donmaffiaButton.alpha = 0.3
            }

            cell.healButton.isHidden = game.roles[Role.Doctor.rawValue] == nil
            cell.maniacButton.isHidden = game.roles[Role.Maniac.rawValue] == nil || player.role == Role.Maniac
            cell.donmaffiaButton.isHidden = game.roles[Role.Don.rawValue] == nil || player.role == Role.Don
            cell.checkButton.isHidden = game.roles[Role.Sherif.rawValue] == nil || player.role == Role.Sherif
            cell.silenceButton.isHidden = game.roles[Role.Prostitute.rawValue] == nil && game.roles[Role.Maniac.rawValue] == nil
            cell.killButton.isHidden = game.roles[Role.Mafia.rawValue] == nil || player.role == Role.Mafia
        }

        return cell
    }
    
    // Обрабатываем события редактирования над таблицей участников
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем элемент массива данных участников игры
            game.removePlayer(at: indexPath.section)
            playersTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !game.isStarted
    }
    
    //MARK: - Обработка действий пользователя
    
    // Нажали кнопку Save на странице добавления пользователя в игру
    @IBAction func unwindToPlayerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddController{
            
            if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
                // Обновляем пользователя в таблице
                if let editPlayer = sourceViewController.editPlayer {
                    game.setPlayer(at: selectedIndexPath.section, element: editPlayer)
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
    func pushMafiaKill(_ sender: UIButton) {
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

    // Нажали кнопку "Проверил дон мафии" в таблице
    @IBAction func pushDonMaffia(_ sender: UIButton) {
        self.createAction(newAction: ActionType.DonCheck, cellRow: sender.tag, ifState: DayNightState.Night)
    }

    // Нажали кнопку "Маньяк убивает" в таблице
    @IBAction func pushManiacKill(_ sender: UIButton) {
        self.createAction(newAction: ActionType.ManiacKill, cellRow: sender.tag, ifState: DayNightState.Night)
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

        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: { (action) in
            
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
        
        let indexPath = IndexPath(item: 0, section: cellRow) // Индекс хода
        let actionPlayer = game.getPlayer(at: indexPath.section) // Над кем(игрок) действие
        
        actionPlayer.toggleAction(action: newAction, turn: game.getCurrentTurnNumber())
        
        playersTableView.reloadData()
    }
}
