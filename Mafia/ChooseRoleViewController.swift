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
        return 10
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
        
        // Визуальное оформление ячейки
        let bgColor = UIColor(rgb: 0xE8E8E8, alpha: 0.6).cgColor
        cellRole.layer.backgroundColor = bgColor
        
        // Данные ячейки
        cellRole.cellName.text = currentRole.title
        cellRole.descriptionLabel.text = currentRole.description
        cellRole.checkButton.isHidden = true
        cellRole.chooseButton.tag = indexPath.section
        cellRole.chooseButton.isEnabled = true
        
        // Меняем иконку текущей роли игрока
        switch currentRole {
        case .Citizen:
            cellRole.roleImage.image = UIImage(named: "Role icon sitizen")
        case .Doctor:
            cellRole.roleImage.image = UIImage(named: "Role icon medic")
        case .Mafia:
            cellRole.roleImage.image = UIImage(named: "Role icon mafia")
        case .Don:
            cellRole.roleImage.image = UIImage(named: "Role icon don maffia")
        case .Maniac:
            cellRole.roleImage.image = UIImage(named: "Role icon maniac")
        case .Prostitute:
            cellRole.roleImage.image = UIImage(named: "Role icon putana")
        case .Sherif:
            cellRole.roleImage.image = UIImage(named: "Role icon sheriff")
        case .Undead:
            cellRole.roleImage.image = UIImage(named: "Role icon undead")
        case .Yacuza:
            cellRole.roleImage.image = UIImage(named: "Role icon yacuza")
        case .Lawyer:
            cellRole.roleImage.image = UIImage(named: "Role icon loyer")
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
    }
}
