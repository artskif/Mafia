//
//  PlayController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 11.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log

//
//  Контроллер окна главного игрового процесса(окно где выведены списки игроков с действиями)
//
class PlayController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - Свойства контроллера
    
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var dayNightButton: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var itemDayNightToolbar: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    var endGame = false // флаг окончания игры

    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваем кнопку меню
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")

        // Регистрируем собственную ячейку(cell) в таблице
        let nib = UINib(nibName: "PlayTableViewCell", bundle: nil)
        playersTableView.register(nib, forCellReuseIdentifier: "PlayTableViewCell")
        
        // Сортируем участников игры
        game.sortPlayers()
        
        // Показываем сообщение хода если нужно
        if !game.turnMessageDidShow {
            showTurnMessages()
            game.turnMessageDidShow = true
        }
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
            
        case "ShowRoles": 
            guard let сhooseRoleViewController = segue.destination as? ChooseRoleViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            сhooseRoleViewController.nameOfBackSegue = "unwindRolesToPlayerList"
            
        default:
            break
        }
    }
    
    // MARK: - Методы управления таблицей участников
    
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
        self.performSegue(withIdentifier: "ShowRoles", sender: self)
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
        cell.yacuzaButton.addTarget(self, action: #selector(pushYacuzaKill), for: UIControlEvents.touchUpInside)
        cell.lawerButton.addTarget(self, action: #selector(pushLawyerGet), for: UIControlEvents.touchUpInside)
        
        
        // Определяем дынные для заполнения ячейки таблицы
        let player = game.getPlayer(at: indexPath.section)
        
        // Заполняем рейтинг ячейки
        let sum = player.currentRating.reduce(0, { x, y in x + y})
        cell.currentRating.text = "\(sum < 1 ? 1 : sum)"
        cell.globalRating.text = "\(player.rating)"
        
        // Заполним данные для кнопок
        cell.killButton.tag = indexPath.section
        cell.healButton.tag = indexPath.section
        cell.checkButton.tag = indexPath.section
        cell.silenceButton.tag = indexPath.section
        cell.donmaffiaButton.tag = indexPath.section
        cell.maniacButton.tag = indexPath.section
        cell.yacuzaButton.tag = indexPath.section
        cell.lawerButton.tag = indexPath.section
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
        case .Yacuza:
            cell.roleImage.image = UIImage(named: "Role icon yacuza")
        case .Lawyer:
            cell.roleImage.image = UIImage(named: "Role icon loyer")
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
            cell.yacuzaButton.isHidden = true
            cell.lawerButton.isHidden = true
            
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
            cell.yacuzaButton.isHidden = true
            cell.lawerButton.isHidden = true
            cell.killButton.isHidden = game.roles[Role.Mafia.rawValue] == nil && game.roles[Role.Yacuza.rawValue] == nil && game.roles[Role.Don.rawValue] == nil && game.roles[Role.Maniac.rawValue] == nil
            
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

            // Отрисовываем нажатие кнопки "Убили Якудза"
            if player.actionCheck(action: ActionType.YacuzaKill) {
                cell.yacuzaButton.alpha = 1
            } else {
                cell.yacuzaButton.alpha = 0.3
            }

            // Отрисовываем нажатие кнопки "Адвокат алиби"
            if player.actionCheck(action: ActionType.LawyerGet) {
                cell.lawerButton.alpha = 1
            } else {
                cell.lawerButton.alpha = 0.3
            }

            cell.healButton.isHidden = game.roles[Role.Doctor.rawValue] == nil
            cell.maniacButton.isHidden = game.roles[Role.Maniac.rawValue] == nil || player.role == Role.Maniac
            cell.donmaffiaButton.isHidden = game.roles[Role.Don.rawValue] == nil || player.role == Role.Mafia || player.role == Role.Don
            cell.checkButton.isHidden = game.roles[Role.Sherif.rawValue] == nil || player.role == Role.Sherif
            cell.silenceButton.isHidden = game.roles[Role.Prostitute.rawValue] == nil && game.roles[Role.Maniac.rawValue] == nil
            cell.killButton.isHidden = (game.roles[Role.Mafia.rawValue] == nil && game.roles[Role.Don.rawValue] == nil) || player.role == Role.Mafia || player.role == Role.Don
            cell.yacuzaButton.isHidden = game.roles[Role.Yacuza.rawValue] == nil || player.role == Role.Yacuza
            cell.lawerButton.isHidden = game.roles[Role.Lawyer.rawValue] == nil || player.role == Role.Lawyer
        }

        return cell
    }
    
    // Обрабатываем события редактирования над таблицей участников
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем элемент массива данных участников игры
            game.removePlayer(at: indexPath.section)
            let indexes = IndexSet(integer: indexPath.section)
            playersTableView.deleteSections(indexes, with: .fade)
            playersTableView.reloadData()
        }
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Обработка действий пользователя
    
    // Выбрали роль на странице выбора ролей
    @IBAction func unwindRolesToPlayerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ChooseRoleViewController{
            
            if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
                // Обновляем пользователя в таблице
                if let newRole = sourceViewController.choosedRole {
                    game.setPlayerRole(at: selectedIndexPath.section, element: Role(rawValue: newRole)!)
                    playersTableView.reloadRows(at: [selectedIndexPath], with: .none)
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
    }
    
    // Нажали кнопку "Доктор вылечил" в таблице
    @IBAction func pushDoctorHeal(_ sender: UIButton) {
        self.createAction(newAction: ActionType.Heal, cellRow: sender.tag, ifState: DayNightState.Night)
    }

    // Нажали кнопку "Якудза убила" в таблице
    @IBAction func pushYacuzaKill(_ sender: UIButton) {
        self.createAction(newAction: ActionType.YacuzaKill, cellRow: sender.tag, ifState: DayNightState.Night)
    }

    // Нажали кнопку "Адвокат дал алиби" в таблице
    @IBAction func pushLawyerGet(_ sender: UIButton) {
        self.createAction(newAction: ActionType.LawyerGet, cellRow: sender.tag, ifState: DayNightState.Night)
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
        
        game.handleTurnActions() // Обрабатываем событие окончания хода
        game.startNewTurn() // Начинаем новый ход
        game.turnMessageDidShow = false // Метка о непоказанном сообщении

        // Далее переходим на экран ночи
        if let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "NightController") as? UINavigationController {
            self.revealViewController().setFront(secondViewController, animated: true)
        }
    }
    
    //MARK: - Методы управления страницей
    
    // Показываем сообщение о событиях дня или ночи
    func showTurnMessages(){
        let popOverVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupStoriboardID") as! PopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        // Показываем игровые собщения окончания хода
        popOverVC.textMessageLabel.text = game.turnTextMessage
        popOverVC.titleLabel.text = game.state == DayNightState.Day ? "НАСТУПИЛА НОЧЬ" : "НАСТУПИЛ ДЕНЬ"
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
