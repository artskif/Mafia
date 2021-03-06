//
//  AddController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 13.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log
import CoreData

//
// Это контроллер добавления новых игроков, а так же выбора роли в случае если игра началась
//
class AddController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var chooseTableView: UITableView!
    @IBOutlet weak var addNewPlayer: UIButton!
    @IBOutlet weak var addUserTableView: UITableView!
    @IBOutlet weak var checkImage: UIImageView!
    
    // MARK: - Свойства контроллера
    
    var playersForChoose: [Player] = []
    
    var newPlayers: [Player] = [] // а сюда запишем пользователей которых хотим добавить в таблицу
    
    var choosedUsers:[Int] = []
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Обрабатывать текстовое поле с помощью делегата которым является текущий контроллер
        nameTextField.delegate = self
        
        let accounts = game.accounts.sorted{$0.name! < $1.name!}
        
        // Необходимо вставить в таблицу выбора игроков которых мы добавили в прошлый раз
        for p in game.getNewPlayers() {
            playersForChoose.append(p)
            choosedUsers.append(playersForChoose.count-1)
        }
        
        for acc in accounts {
            if game.checkPlayerId(idItem: acc.id) {
                self.playersForChoose.append(game.getPlayerBy(id: acc.id)!)
                choosedUsers.append(playersForChoose.count-1)
            } else {
                self.playersForChoose.append(Player(baseObject: acc)!)
            }
        }

        if (playersForChoose.count == 0) {
            self.performSegue(withIdentifier: "showPopover1", sender: self)
        }
        
        // Включить кнопку Add только если контроллер содержит валидные данные для сохранения
        updateAddButtonState()
       
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navbar_bg_dark"), for: .default)
        
        chooseTableView.rowHeight = 44.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Этот метод дает возможность сконфигурировать контроллер до того как он покажется пользователю
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // обработка поведения нового контроллера в зависимости от того каким переходом(segue) мы пользуемся
        switch(segue.identifier ?? "") {
        case "AddButton":
            game.clearPlayers() // сначала всех удаляем
            newPlayers.removeAll()

            for selected in choosedUsers {
                let newPlayer = playersForChoose[selected]
                newPlayers.append(newPlayer)
            }
            
            // Что бы каждый раз не обновлять роли добавляем игроков один раз
            if newPlayers.count > 0 {
                game.addPlayers(players: newPlayers)
            }
            
            // Сортируем участников игры
            game.sortPlayers()
        case "showPopover1":
            let popVC = segue.destination
            popVC.popoverPresentationController?.delegate = self
        case "showPopover2":
            let popVC = segue.destination
            popVC.popoverPresentationController?.delegate = self
        default:
            break
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Методы инициализации таблицы выбора участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        // У нас в таблице аккаунты пользователей
        return playersForChoose.count
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
        let cellIdentifer = "ChooseTableViewCell"
        
        // В данном варианте мы не редактируем пользователя - мы выбираем  нового
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? ChooseTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ChooseTableViewCell.")
        }
        
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
        cell.checkImage.isHidden = true
        
        // Начинаем отрисовку игроков
        let account = playersForChoose[indexPath.section]
        
        // Задаем данные для ячейки
        cell.cellName.text = account.name
        cell.numbelLabel.text = "\(indexPath.section + 1)."
        cell.chooseButton.tag = indexPath.section
        cell.chooseButton.isEnabled = true
        
        // если мы уже добавили подобного игрока то его добавлять уже не нужно
        //if game.checkPlayerId(idItem: account.id) {
        //    cell.chooseButton.isEnabled = false
        //    cell.checkImage.isHidden = false
        //}
        
        // Последнюю красную прерывистую линию не показываем
        if (indexPath.section + 1) == tableView.numberOfSections {
            cell.dottedLine.isHidden = true
        } else {
            cell.dottedLine.isHidden = false
        }
        
        // выбранных игроков выбирать не нужно
        if choosedUsers.contains(indexPath.section) {
            cell.checkImage.isHidden = false
        }
        return cell
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
        if choosedUsers.contains(sender.tag) {
            if let index = choosedUsers.index(of: sender.tag) {
                choosedUsers.remove(at: index)
            }
        } else {
            choosedUsers.append(sender.tag)
        }
        saveButton.isEnabled = true
        chooseTableView.reloadData()
    }
    
    // Добавляем нового участника в список для выбора
    @IBAction func addNewPlayer(_ sender: UIButton) {
        if let newName = nameTextField.text {
            if !newName.isEmpty {
                let newAccountForChoose:Player = Player(id: 0, name: newName, rating: 0)!
                
                playersForChoose.insert(newAccountForChoose, at: 0)
                nameTextField.text = ""
                updateAddButtonState()
                for (key, value) in choosedUsers.enumerated() {
                    choosedUsers[key] = value + 1
                }
                choosedUsers.append(0)
                
                // Анимированно обновляем строки таблицы
                let othersIndexPaths = chooseTableView.indexPathsForVisibleRows!
                chooseTableView.beginUpdates()
                let indexes = IndexSet(integer: 0)
                addUserTableView.insertSections(indexes, with: .automatic)
                chooseTableView.reloadRows(at: othersIndexPaths, with: .fade)
                chooseTableView.endUpdates()
                
                if (playersForChoose.count == 1) {
                    self.performSegue(withIdentifier: "showPopover2", sender: self)
                }
            }
        }
        
    }
    
    // Сохраняем новых участников и переходим на экран игры
    @IBAction func saveNewPlayers(_ sender: Any) {
        game.clearPlayers() // сначала всех удаляем
        newPlayers.removeAll()
        
        for selected in choosedUsers {
            let newPlayer = playersForChoose[selected]
            newPlayers.append(newPlayer)
        }
        
        // Что бы каждый раз не обновлять роли добавляем игроков один раз
        if newPlayers.count > 0 {
            game.addPlayers(players: newPlayers)
        }
        
        // Сортируем участников игры
        game.sortPlayers()
        
        var nextController = ""
        if game.state == DayNightState.Day {
            nextController = "PlayController"
        }else{
            nextController = "NightController"
        }
        
        if let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: nextController) as? UINavigationController {
            self.revealViewController().setFront(secondViewController, animated: true)
        }
    }
    
    // Нажали кнопку редактировать игроков на странице Игры
    @IBAction func unwindAddPlayerFromPlayController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PlayController {
            // Ничего не делаем
        }
    }
    
    // Обновить состояние кнопки Add в зависимости от состояния тектового поля имени пользователя
    private func updateAddButtonState() {
        if (nameTextField.text?.isEmpty)! {
            addNewPlayer.isEnabled = false
        } else {
            addNewPlayer.isEnabled = true
        }
    }
}
