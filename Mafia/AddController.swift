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
    
    // MARK: - Свойства контроллера
    
    var player: Player?
    var choosedNumber:Int?
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Обрабатывать текстовое поле с помощью делегата которым является текущий контроллер
        nameTextField.delegate = self
        
        // Настройка текстового поля если мы редактируем, а не добавляем пользователя
        if let player = player {
            nameTextField.text   = player.name
            choosedNumber = player.role.hashValue
        }
        
        // Включить кнопку Save только если контроллер содержит валидные данные для сохранения
        updateSaveButtonState()
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
        
        if let currentChoosed = choosedNumber {
            if let editPlayer = player {
                editPlayer.name = name
                editPlayer.role = Role(rawValue: currentChoosed)!
            } else {
                let newPlayer = game.accounts[currentChoosed]
                player = Player(baseObject: newPlayer)
            }
        } else  {
            player = Player(name: name)
        }
    }
    
    // MARK: - Методы инициализации таблицы выбора участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // У нас в таблице или аккаунты пользователей или роли пользователя
        if player == nil {
            return game.accounts.count
        } else {
            return Role.count
        }
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "ChooseTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ChooseTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlayerTableViewCell.")
        }
        
        cell.chooseButton.tag = indexPath.row

        
        if player == nil {
            // Определяем дынные для заполнения ячейки таблицы
            let account = game.accounts[indexPath.row]
            cell.cellName.text = account.name
        } else {
            // Если мы редактируем ячейку то мы выбираем роль
            cell.cellName.text = Role(rawValue: indexPath.row)?.description
        }
        
        if let currentChoosed = choosedNumber {
            cell.chooseButton.isEnabled = currentChoosed != cell.chooseButton.tag
        }
        
        return cell
    }
    
    // Определяем возможность редактировать таблицу выбора участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - Обработка действий пользователя
    
    // кнопка "Готово" на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // Событие на печать текста внутри текстового поля имени пользователя
    @IBAction func editingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Нажата кнопка "Выбрать" в таблице выбора участников игры
    @IBAction func chooseButton(_ sender: UIButton) {
        choosedNumber = sender.tag
        saveButton.isEnabled = true
        nameTextField.isEnabled = false
        chooseTableView.reloadData()
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
    
    // Обновить состояние кнопки Save в зависимости от состояния тектового поля имени пользователя
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
