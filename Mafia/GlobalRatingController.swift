//
//  GlobalRatingController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 17.05.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

//
//  Контроллер экрана общего рейтинга (Кнопка Рейтинг в меню главного окна)
//
class GlobalRatingController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ratingTable: UITableView!
    var filteredAccounts:[UserAccount] = []
    var ratingType: String = "main"
    let pickerRatingRows = ["Общий рейтинг", "Процент побед", "Выживаемость", "Игр сыграно"]
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "Показывается с первой игры"
        
        filteredAccounts = game.accounts.filter({$0.numberOfGames>0})
        filteredAccounts = filteredAccounts.sorted{$0.rating > $1.rating}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Методы инициализации контрола выбора
    
    // Количество компонент
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Количество строк в контроле выбора
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerRatingRows.count
    }
    
    // Заголовки в контроле выбора
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerRatingRows[row]
    }
    
    // Обработка переходов между элементами в контроле выбора
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            filteredAccounts = game.accounts.filter({$0.numberOfGames>0})
            filteredAccounts = filteredAccounts.sorted{$0.rating > $1.rating}
            ratingType = "main"
            infoLabel.text = "Показывается с первой игры"
            ratingTable.reloadData()
        case 1:
            filteredAccounts = game.accounts.filter({$0.numberOfGames>4})
            filteredAccounts = filteredAccounts.sorted{Double($0.numberOfWins) / Double($0.numberOfGames) > Double($1.numberOfWins) / Double($1.numberOfGames)}
            ratingType = "wins"
            infoLabel.text = "Показывается с пятой игры"
            ratingTable.reloadData()
        case 2:
            filteredAccounts = game.accounts.filter({$0.numberOfGames>4})
            filteredAccounts = filteredAccounts.sorted{Double($0.numberOfTurns) / Double($0.numberOfGames) > Double($1.numberOfTurns) / Double($1.numberOfGames)}
            ratingType = "alive"
            infoLabel.text = "Показывается с пятой игры"
            ratingTable.reloadData()
        case 3:
            filteredAccounts = game.accounts.filter({$0.numberOfGames>0})
            filteredAccounts = filteredAccounts.sorted{$0.numberOfGames > $1.numberOfGames}
            ratingType = "games"
            infoLabel.text = "Показывается с первой игры"
            ratingTable.reloadData()
        default:
            filteredAccounts = game.accounts
            filteredAccounts = filteredAccounts.sorted{$0.rating > $1.rating}
            ratingType = "main"
            ratingTable.reloadData()
        }
    }
    
    // MARK: - Методы инициализации таблицы рейтинга
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        switch ratingType {
        case "main":
            return game.accounts.filter({$0.numberOfGames>0}).count
        case "wins":
            return game.accounts.filter({$0.numberOfGames>4}).count
        case "alive":
            return game.accounts.filter({$0.numberOfGames>4}).count
        case "games":
            return game.accounts.filter({$0.numberOfGames>0}).count
        default:
            return game.accounts.count
        }
    }
    
    // Расстояние между ячейками(секциями)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Описываем состояние заголовка секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RatingViewCell", for: indexPath) as? RatingTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RatingViewCell.")
        }
        
        // Какие данные будем использовать для текущей обрабатываемой ячейки
        let account = filteredAccounts[indexPath.section]
        
        // Визуально оформляем ячейку
        cell.layer.cornerRadius = 0
        let evenColor = UIColor(rgb: 0xB88E8E, alpha: 0.1).cgColor
        let oddColor = UIColor(rgb: 0xB88E8E, alpha: 0).cgColor
        
        if indexPath.section % 2 == 0 {
            cell.layer.backgroundColor = oddColor
        } else {
            cell.layer.backgroundColor = evenColor
        }
        
        cell.labelName.text = account.name!
        switch ratingType {
        case "main":
            cell.labelRating.text = "\(account.rating)"
        case "wins":
            cell.labelRating.text = account.numberOfGames > 0 ? "\(lround(Double(account.numberOfWins) / Double(account.numberOfGames) * 100))" : "0"
        case "alive":
            cell.labelRating.text = account.numberOfGames > 0 ? "\(Double(round(10*Double(account.numberOfTurns) / Double(account.numberOfGames))/10))" : "0"
        case "games":
            cell.labelRating.text = "\(account.numberOfGames)"
        default:
            cell.labelRating.text = "\(account.rating)"
            
        }
        cell.labelPosition.text = "\(indexPath.section + 1)"
        
        // Последнюю красную прерывистую линию не показываем
        if (indexPath.section + 1) == tableView.numberOfSections {
            cell.dottedLine.isHidden = true
        } else {
            cell.dottedLine.isHidden = false
        }
        
        return cell

    }
    
    //MARK: - Обработка действий пользователя
    
    @IBAction func clearStatistics(_ sender: Any) {
        
        let alert = UIAlertController(title: "Сброс статистики", message: "Хотите Сбросить статистику?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: { (action) in
            for acc in game.accounts {
                acc.rating = 0
                acc.numberOfWins = 0
                acc.numberOfGames = 0
                acc.numberOfTurns = 0
            }
            game.saveAccounts()
            self.ratingTable.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
