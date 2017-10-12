//
//  NightRolesViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 11.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class NightRolesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var actionTableHeight: NSLayoutConstraint!
    @IBOutlet weak var playersTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dayNightButton: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var itemDayNightToolbar: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    // MARK: - События контроллера

    var roleActions : [ActionType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваем кнопку меню
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        
    }

    override func viewDidLayoutSubviews(){
        actionTableHeight.constant = actionTableView.contentSize.height
        playersTableHeight.constant = playersTableView.contentSize.height
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
        if tableView == actionTableView {
            var numRoles: Int = 0
            for r in game.roles {
                numRoles += Int(r.value.roleNightActions.count)
                roleActions.append(contentsOf: r.value.roleNightActions)
            }
            
            return numRoles
        } else {
            return game.countPlayers()
        }
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
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == actionTableView) {
            let cellIdentifer = "ActionsTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ActionsTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ChoosePlayerRoleTableViewCell.")
            }
            
            let role = roleActions[indexPath.section]
            
            cell.nameLabel?.text = role.description
            return cell
        } else {
            let cellIdentifer = "ChoosePlayerRoleTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ChoosePlayerRoleTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ChoosePlayerRoleTableViewCell.")
            }
            
            // Определяем дынные для заполнения ячейки таблицы
            let player = game.getPlayer(at: indexPath.section)
            
            cell.nameLabel.text = player.name
            
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
            return cell
        }
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
