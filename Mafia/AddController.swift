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
    
    // MARK: - Свойства контроллера
    
    var player: Player?
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Обрабатывать текстовое поле с помощью делегата которым является текущий контроллер
        nameTextField.delegate = self
        
        // Настройка текстового поля если мы редактируем, а не добавляем пользователя
        if let player = player {
            nameTextField.text   = player.name
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
        
        player = Player(name: name)
    }
    
    // MARK: - Методы инициализации таблицы выбора участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.accounts.count
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "ChooseTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ChooseTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlayerTableViewCell.")
        }
        
        // Определяем дынные для заполнения ячейки таблицы
        let account = game.accounts[indexPath.row]
        
        cell.chooseButton.tag = indexPath.row
        cell.accountName.text = account.name
        
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
