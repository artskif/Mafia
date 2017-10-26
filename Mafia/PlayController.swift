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
        
        // Меняем фон навигационной панели
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navbar_bg_dark"), for: .default)
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
            
            guard let roleButton = sender as? UIButton else {
                fatalError("Unexpected sender: \(sender.debugDescription)")
            }
            
            let selectedPlayer = game.getPlayer(at: roleButton.tag)
            сhooseRoleViewController.choosedPlayer = selectedPlayer
            сhooseRoleViewController.nameOfBackSegue = "unwindRolesToPlayerList"
        case "ShowProperties":
            guard let propertiesViewController = segue.destination as? PropertiesController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let propertiesButton = sender as? UIButton else {
                fatalError("Unexpected sender: \(sender.debugDescription)")
            }
            
            let selectedPlayer = game.getPlayer(at: propertiesButton.tag)
            propertiesViewController.choosedPlayer = selectedPlayer
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
        return 0
    }
    
    // Описываем состояние заголовка секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "PlayTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? PlayTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlayTableViewCell.")
        }
        
        // Вешаем обработчики событий на кнопки
        cell.killButton.addTarget(self, action: #selector(pushCitizenKill), for: UIControlEvents.touchUpInside)
        cell.showPropertiesButton.addTarget(self, action: #selector(pushPropertiesButton), for: UIControlEvents.touchUpInside)
        cell.showRoleButton.addTarget(self, action: #selector(pushShowRole), for: UIControlEvents.touchUpInside)
        
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
        
        // Определяем дынные для заполнения ячейки таблицы
        let player = game.getPlayer(at: indexPath.section)
        
        // Заполняем рейтинг ячейки
        let sum = player.currentRating.reduce(0, { x, y in x + y})
        cell.currentRating.text = "\(sum)"
        
        // Заполним данные для кнопок
        cell.showRoleButton.tag = indexPath.section
        cell.showPropertiesButton.tag = indexPath.section
        cell.killButton.tag = indexPath.section
        cell.nameLabel.text = player.name
        cell.numberLaber.text = "\(indexPath.section + 1)."
        cell.ripLabel.isHidden = true
        
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
                
        // Ячейка мертвого пользователя
        if player.stateAlive == AliveState.Dead {
            cell.ripLabel.isHidden = false
            cell.isUserInteractionEnabled = false
            cell.killButton.isHidden = true
            cell.choosedImage.isHidden = true
            cell.linkLabel.isHidden = true
            
            return cell
        } else {
            cell.isUserInteractionEnabled = true
            cell.ripLabel.isHidden = true
            
            // Отрисовываем нажатие кнопки "Убить"
            if player.actionCheck(action: ActionType.CitizenKill) {
                cell.choosedImage.isHidden = false
                cell.linkLabel.isHidden = true
                
                let choosedColor = UIColor(rgb: 0xB88E8E, alpha: 0.4).cgColor
                // Выделяем цветом наминированного игрока
                cell.layer.backgroundColor = choosedColor
            } else {
                cell.choosedImage.isHidden = true
                cell.linkLabel.isHidden = false
            }
        }

        // Последнюю красную прерывистую линию не показываем
        if (indexPath.section + 1) == tableView.numberOfSections {
            cell.dottedLine.isHidden = true
        } else {
            cell.dottedLine.isHidden = false
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
        if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
            // Обновляем пользователя в таблице
            playersTableView.reloadRows(at: [selectedIndexPath], with: .none)
            
        }
        
        // Сортируем участников игры
        game.sortPlayers()
        playersTableView.reloadData()
    }
    
    // Нажали кнопку Cancel на странице добавления пользователя в игру
    @IBAction func unwindCancelToPlayerList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
            // Сбрасываем выбранную ячейку в таблице при нажатии на кнопку Cancel
            playersTableView.deselectRow(at: selectedIndexPath, animated: false)
        }
    }

    // Нажали кнопку "Выбрать роль" в таблице
    func pushShowRole(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowRoles", sender: sender)
    }
    
    // Нажали кнопку "Показать параметры" в таблице
    func pushPropertiesButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowProperties", sender: sender)
    }

    // Нажали кнопку "Горожане убивают" в таблице
    func pushCitizenKill(_ sender: UIButton) {
        self.createAction(newAction: ActionType.CitizenKill, cellRow: sender.tag)
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
        popOverVC.titleLabel.text = game.state == DayNightState.Night ? "НАСТУПИЛА НОЧЬ" : "НАСТУПИЛ ДЕНЬ"
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
