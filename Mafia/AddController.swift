//
//  AddController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 13.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log

class AddController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var chooseTableView: UITableView!
    @IBOutlet weak var addNewPlayer: UIButton!
    @IBOutlet weak var addUserTableView: UITableView!
    @IBOutlet weak var checkImage: UIImageView!
    
    // MARK: - Свойства контроллера
    
    var playersForChoose: [Account] = []
    
    var editPlayer: Player? // сюда записываем пользователя которого редактируем
    var newPlayers: [Player] = [] // а сюда запишем пользователей которых хотим добавить в таблицу
    
    var choosedRole:Int?
    var choosedUsers:[Int] = []
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Обрабатывать текстовое поле с помощью делегата которым является текущий контроллер
        nameTextField.delegate = self
        
        self.playersForChoose = game.accounts.sorted{$0.name < $1.name}

        // Настройка текстового поля если мы редактируем, а не добавляем пользователя
        if let editPlayer = self.editPlayer {
            nameTextField.text   = editPlayer.name
            choosedRole = editPlayer.role.rawValue
            addNewPlayer.isEnabled = false
        }
        
        // Включить кнопку Add только если контроллер содержит валидные данные для сохранения
        updateAddButtonState()
        
        if game.isStarted {
            chooseTableView.isHidden = true
        }
        
        if editPlayer == nil {
            chooseTableView.rowHeight = 50.0
        } else {
            chooseTableView.rowHeight = 68.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Этот метод дает возможность сконфигурировать контроллер до того как он покажется пользователю
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        
        // заполняем данные для возврата их из контроллера
        if let editPlayer = editPlayer {
            editPlayer.name = name
            editPlayer.role = Role(rawValue: choosedRole!)!
        } else {
            for selected in choosedUsers {
                let newPlayer = playersForChoose[selected]
                newPlayers.append(Player(baseObject: newPlayer)!)
            }
        }
    }
    
    // MARK: - Методы инициализации таблицы выбора участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        // У нас в таблице или аккаунты пользователей или роли пользователя(если мы редактируем пользователя)
        if editPlayer == nil {
            return playersForChoose.count
        } else {
            return Role.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы выбора поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "ChooseTableViewCell"
        let cellRoleIdentifer = "ChooseRatingTableViewCell"
        
        if editPlayer == nil {
            // В данном варианте мы не редактируем пользователя - мы выбираем  нового
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ChooseTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ChooseTableViewCell.")
            }

            // Визуально оформляем ячейку
            cell.layer.cornerRadius = 8
            let evenColor = UIColor(rgb: 0xD8D8D8, alpha: 0.1).cgColor
            let oddColor = UIColor(rgb: 0xD8D8D8, alpha: 0.4).cgColor
            
            if indexPath.section % 2 == 0 {
                cell.layer.backgroundColor = oddColor
            } else {
                cell.layer.backgroundColor = evenColor
            }
            cell.checkImage.isHidden = true
            
            let account = playersForChoose[indexPath.section]

            cell.chooseButton.tag = indexPath.section
            cell.chooseButton.isEnabled = true
            
            // Задаем имена для ячейки
            cell.cellName.text = "\(account.name)"
            cell.numbelLabel.text = "\(indexPath.section + 1)"
            
            // если мы уже добавили подобного игрока то его добавлять уже не нужно
            if game.checkPlayerId(idItem: account.id) {
                cell.chooseButton.isEnabled = false
                cell.checkImage.isHidden = false
            }
            
            // выбранных игроков выбирать не нужно
            if choosedUsers.contains(indexPath.section) {
                cell.chooseButton.isEnabled = false
                cell.checkImage.isHidden = false
            }
            return cell
        } else {
            // В данном варианте мы редактируем пользователя,
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
            }
            
            if let currentChoosedRole = choosedRole {
                // Имеется выбранный вариант таблицы (выбора ролей)
                
                // если нажата кнопка выбора то мы ее отключаем (во избежании дальнейших нажатий этой кнопки)
                cellRole.checkButton.isHidden = currentChoosedRole != cellRole.chooseButton.tag
            }
            return cellRole
        }
    }
    
    // Определяем возможность редактировать таблицу выбора участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Обработка действий пользователя
    
    // кнопка "Готово" на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // Событие на печать текста внутри текстового поля имени пользователя
    @IBAction func editingChanged(_ sender: UITextField) {
        updateAddButtonState()
    }
    
    // Нажата кнопка "Выбрать" в таблице выбора участников/ролей игры
    @IBAction func chooseButton(_ sender: UIButton) {
        if editPlayer == nil {
            choosedUsers.append(sender.tag)
        } else {
            choosedRole = sender.tag
        }
        saveButton.isEnabled = true
        chooseTableView.reloadData()
    }
    
    // Добавляем нового участника в список для выбора
    @IBAction func addNewPlayer(_ sender: UIButton) {
        if let newName = nameTextField.text {
            if !newName.isEmpty {
                let newAccountForChoose = Account(id: 0, name: newName)
                playersForChoose.insert(newAccountForChoose!, at: 0)
                nameTextField.text = ""
                updateAddButtonState()
                for (key, value) in choosedUsers.enumerated() {
                    choosedUsers[key] = value + 1
                }
                //choosedUsers = []
                
                // Анимированно обновляем строки таблицы
                let othersIndexPaths = chooseTableView.indexPathsForVisibleRows!
                chooseTableView.beginUpdates()
                let indexes = IndexSet(integer: 0)
                addUserTableView.insertSections(indexes, with: .automatic)
                chooseTableView.reloadRows(at: othersIndexPaths, with: .fade)
                chooseTableView.endUpdates()
            }
        }
        
    }
    
    // Нажали кнопку Cancel в навигационной панели страницы
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        // Обработка нажатия зависит от способа вызова контроллера (modal or push presentation), данные контроллер будет уничтожен 2 разными способами
        let isPresentingInAddPlayerMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPlayerMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The AddController is not inside a navigation controller.")
        }
    }
    
    // Обновить состояние кнопки Add в зависимости от состояния тектового поля имени пользователя
    private func updateAddButtonState() {
        if (nameTextField.text?.isEmpty)! {
            addNewPlayer.isEnabled = false
        } else {
            addNewPlayer.isEnabled = true
        }
        
        if self.editPlayer != nil {
            addNewPlayer.isEnabled = false
        }
    }
}
