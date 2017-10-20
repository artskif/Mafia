//
//  ChooseRoleViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 06.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class ChooseRoleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chooseTableView: UITableView!
    @IBOutlet weak var checkImage: UIImageView!

    // MARK: - Свойства контроллера

    var choosedRole:Int?
    var nameOfBackSegue:String?
    
    // MARK: - События контроллера

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Методы инициализации таблицы выбора участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        // У нас в таблице роли пользователя
        return Role.count
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
        // Ничего не делаем
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы выбора поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRoleIdentifer = "ChooseRatingTableViewCell"
        
        
        // В данном варианте мы выбираем роли,
        // следовательно должны показать роли для возможности сменить роль(выбранного персонажа)
        
        guard let cellRole = tableView.dequeueReusableCell(withIdentifier: cellRoleIdentifer, for: indexPath) as? ChooseRatingTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ChooseRatingTableViewCell.")
        }
        
        let currentRole = Role(rawValue: indexPath.section)!
        
        // Визуально оформляем ячейку
        cellRole.layer.cornerRadius = 0
        let evenColor = UIColor(rgb: 0xB88E8E, alpha: 0.1).cgColor
        let oddColor = UIColor(rgb: 0xB88E8E, alpha: 0).cgColor
        
        // Разноцвет между соседними ячейками
        if indexPath.section % 2 == 0 {
            cellRole.layer.backgroundColor = oddColor
        } else {
            cellRole.layer.backgroundColor = evenColor
        }
        
        // Данные ячейки
        cellRole.cellName.text = currentRole.title
        cellRole.checkButton.isHidden = true
        cellRole.chooseButton.tag = indexPath.section
        cellRole.chooseButton.isEnabled = true
        
        // Меняем иконку текущей роли игрока
        switch currentRole {
        case .Citizen:
            cellRole.roleImage.image = UIImage(named: "Citizen")
        case .Doctor:
            cellRole.roleImage.image = UIImage(named: "Doctor")
        case .Mafia:
            cellRole.roleImage.image = UIImage(named: "Mafia")
        case .Don:
            cellRole.roleImage.image = UIImage(named: "Don")
        case .Maniac:
            cellRole.roleImage.image = UIImage(named: "Maniac")
        case .Prostitute:
            cellRole.roleImage.image = UIImage(named: "Putana")
        case .Sherif:
            cellRole.roleImage.image = UIImage(named: "Sheriff")
        case .Undead:
            cellRole.roleImage.image = UIImage(named: "Undead")
        case .Yacuza:
            cellRole.roleImage.image = UIImage(named: "Yakudza")
        case .Lawyer:
            cellRole.roleImage.image = UIImage(named: "Lawyer")
        }
        
        if let currentChoosedRole = choosedRole {
            // Имеется выбранный вариант таблицы (выбора ролей)
            // если нажата кнопка выбора то мы ее отключаем (во избежании дальнейших нажатий этой кнопки)
            cellRole.checkButton.isHidden = currentChoosedRole != cellRole.chooseButton.tag
        }
        
        return cellRole
    }
    
    // Определяем возможность редактировать таблицу выбора участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    //MARK: - Обработка действий пользователя
    
    // Нажата кнопка "Выбрать" в таблице выбора ролей игры
    @IBAction func chooseButton(_ sender: UIButton) {
        choosedRole = sender.tag
        chooseTableView.reloadData()
        
        self.performSegue(withIdentifier: self.nameOfBackSegue!, sender: self)
    }
}
