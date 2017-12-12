//
//  MenuTableViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 10.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Свойства контроллера
    
    @IBOutlet weak var menuTable: UITableView!
    
    let cells = ["back_to_day", "players" , "rating" , "help" , "finish_game"]
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        menuTable.reloadData() // Обновляем меню каждый раз как показываем
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Методы инициализации таблицы рейтинга
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    // Расстояние между ячейками(секциями)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Реагируем на нажатия меню
        let cellName = cells[indexPath.section]
        switch cellName {
        case "finish_game":
            // Заканчиваем игру
            let alert = UIAlertController(title: "Завершение игры", message: "Хотите сохранить рейтинг?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: { (action) in
                self.finishCurrentGame(saveRating: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.default, handler: { (action) in
                self.finishCurrentGame(saveRating: false)
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellName = cells[indexPath.section]
        if cellName == "back_to_day" && game.state == DayNightState.Night {
            cellName = "back_to_night"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        return cell
    }
    
    // Завершаем текущую игру
    func finishCurrentGame(saveRating: Bool) {
        self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
        
        if saveRating {game.saveRating()}
    }
    
}
