//
//  MenuTableViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 10.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Методы инициализации таблицы рейтинга
    
    // Количество секций в таблице
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    // Расстояние между ячейками(секциями)
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Кличесто элементов в одной секции таблицы
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Описываем состояние заголовка секции
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Определяем возможность редактировать таблицу участников
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = ["back_to_game", "settings" , "rating" , "players" , "finish_game"]
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section], for: indexPath)
        
        return cell
    }

}
