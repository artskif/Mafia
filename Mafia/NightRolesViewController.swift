//
//  NightRolesViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 11.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class NightRolesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var topPlayersToActions: NSLayoutConstraint!
    @IBOutlet weak var topPlayersView: NSLayoutConstraint!
    @IBOutlet weak var actionTableHeight: NSLayoutConstraint!
    @IBOutlet weak var playersTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var playersView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var dayNightButton: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var itemDayNightToolbar: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    // MARK: - События контроллера

    var roleActions : [ActionType] = []
    var chosedActions : [ActionType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваем кнопку меню
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        
        // Получаем активные действия которые могут делать пользователи
        roleActions = game.getRoleActions()
        
        // Делаем навигационную панель прозрачной
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Скрываем действия игроков если активных ролей еще не выбрано
        if (roleActions.count==0){
            actionView.isHidden = true
            topPlayersView.priority = 999
            topPlayersToActions.priority = 900
        }
        
        // Если игра уже началась то пользователей для выбора роли не показыв
        if game.turnNumber > 1 {
            playersView.isHidden = true
            playersTableHeight.constant = 0
        }
        
        // Показываем сообщение хода если нужно
        if !game.turnMessageDidShow {
            showTurnMessages()
            game.turnMessageDidShow = true
        }
        
        if (game.accounts.count == 0 && game.turnNumber == 1) {
            self.performSegue(withIdentifier: "showPopover1", sender: self)
        }
    }

    override func viewDidLayoutSubviews(){
        actionTableHeight.constant = actionTableView.contentSize.height
        if game.turnNumber < 2 { playersTableHeight.constant = playersTableView.contentSize.height }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Метод вызываемый непосредственно перед навигацией по контроллерам(служит для передачи данных между контроллерами)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // обработка поведения нового контроллера в зависимости от того каким переходом(segue) мы пользуемся
        switch(segue.identifier ?? "") {
            
        case "ShowRolesFromNight": // Показать роли для выбора роли
            guard let сhooseRoleViewController = segue.destination as? ChooseRoleViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
                let selectedPlayer = game.getPlayer(at: selectedIndexPath.section)
                сhooseRoleViewController.choosedPlayer = selectedPlayer
            }
            
            сhooseRoleViewController.nameOfBackSegue = "unwindRolesToNightPlayerList"
        case "ChoosePlayerForAction": // Показать игроков для выбора игрока
            guard let actionChoosedViewController = segue.destination as? ActionChoosedViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            if let selectedIndexPath = actionTableView.indexPathForSelectedRow {
                let selectedAction = roleActions[selectedIndexPath.section]
                actionChoosedViewController.choosedAction = selectedAction
            }
        case "showPopover1":
            let popVC = segue.destination
            popVC.popoverPresentationController?.delegate = self
        default:
        break
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Методы управления таблицей участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == actionTableView {
            return roleActions.count
        } else {
            return game.countPlayers()
        }
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
        
        if (tableView == actionTableView) {
            let cellIdentifer = "ActionsTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ActionsTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ChoosePlayerRoleTableViewCell.")
            }
            
            let role = roleActions[indexPath.section]
            
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
            
            // Заполним данные для кнопок и текста
            if chosedActions.index(of: role) != nil {
                cell.chooseButton.isHidden = true
                cell.choosedLabel.isHidden = false
            } else {
                cell.chooseButton.isHidden = false
                cell.choosedLabel.isHidden = true
            }
            cell.nameLabel?.text = role.description
            
            // Меняем иконку текущей роли игрока
            switch role.correspondingRole {
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
            
            // Последнюю красную прерывистую линию не показываем
            if (indexPath.section + 1) == tableView.numberOfSections {
                cell.dottedLine.isHidden = true
            } else {
                cell.dottedLine.isHidden = false
            }
            
            return cell
        } else {
            let cellIdentifer = "ChoosePlayerRoleTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ChoosePlayerRoleTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ChoosePlayerRoleTableViewCell.")
            }
            
            // Определяем дынные для заполнения ячейки таблицы
            let player = game.getPlayer(at: indexPath.section)
            
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
            
            // Заполним данные для кнопок и текста
            cell.nameLabel.text = player.name
            
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
            
            // Последнюю красную прерывистую линию не показываем
            if (indexPath.section + 1) == tableView.numberOfSections {
                cell.dottedLine.isHidden = true
            } else {
                cell.dottedLine.isHidden = false
            }

            
            return cell
        }
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Обработка действий пользователя
    
    // Выбрали роль на странице выбора ролей
    @IBAction func unwindRolesToNightPlayerList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
            // Обновляем пользователя в таблице
            playersTableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        
        // Сортируем участников игры
        game.sortPlayers()
        
        // Получаем активные действия которые могут делать пользователи
        game.reloadRoles()
        roleActions = game.getRoleActions()
        
        // Скрываем или показываем действия игроков если таковые имеются
        if (roleActions.count==0){
            actionView.isHidden = true
            topPlayersView.priority = 999
            topPlayersToActions.priority = 900
        } else {
            actionView.isHidden = false
            topPlayersView.priority = 900
            topPlayersToActions.priority = 999
        }
        
        actionTableView.reloadData()
        playersTableView.reloadData()
        
        actionTableHeight.constant = actionTableView.contentSize.height
        if game.turnNumber < 2 { playersTableHeight.constant = playersTableView.contentSize.height }
        
    }
    
    // Выбрали пользователя для ночного действия
    @IBAction func unwindActionPlayersToNightPlayerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ActionChoosedViewController{
            if chosedActions.index(of: sourceViewController.choosedAction!) == nil {
                // Запоминаем выполненное над пользователем действие если таковое еще не производилось
                chosedActions.append(sourceViewController.choosedAction!)
            }
            
            // Снимаем выделение с выделенной ячейки
            if let selectedIndexPath = actionTableView.indexPathForSelectedRow {
                actionTableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            actionTableView.reloadData()
        }
    }
    
    // Отменили выбор пользователя для ночного действия
    @IBAction func unwindCancelToNightPlayerList(sender: UIStoryboardSegue) {
        // Снимаем выделение с выделенной ячейки
        if let selectedIndexPath = actionTableView.indexPathForSelectedRow {
            actionTableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        actionTableView.reloadData()
        
    }
    
    @IBAction func showDayButton(_ sender: Any) {
        game.handleTurnActions() // Обрабатываем событие окончания хода
        game.startNewTurn() // Начинаем новый ход
        game.turnMessageDidShow = false // Метка о непоказанном сообщении

        game.refreshStatPlayers() // Обновляем статистику игроков
        
        // Далее переходим на экран ночи
        if let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlayController") as? UINavigationController {
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
    
}
