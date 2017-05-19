//
//  GlobalRatingController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 17.05.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class GlobalRatingController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Элементы управления контроллера
    
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.accounts = game.accounts.sorted{$0.rating > $1.rating}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Методы инициализации таблицы рейтинга
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return game.accounts.count
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
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RatingViewCell", for: indexPath) as? RatingTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RatingViewCell.")
        }
        
        // Какие данные будем использовать для текущей обрабатываемой ячейки
        let account = game.accounts[indexPath.section]
        
        cell.layer.cornerRadius = 8
        let evenColor = UIColor(rgb: 0xD8D8D8, alpha: 0.1).cgColor
        let oddColor = UIColor(rgb: 0xD8D8D8, alpha: 0.4).cgColor
        
        if indexPath.section % 2 == 0 {
            cell.layer.backgroundColor = oddColor
        } else {
            cell.layer.backgroundColor = evenColor
        }
        
        cell.labelName.text = account.name
        cell.labelRating.text = "\(account.rating)"
        cell.labelPosition.text = "\(indexPath.section + 1)"
        
        return cell

    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Обработка действий пользователя
    
    //@IBAction func cancelTab(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
    //    let isPresentingInAddPlayerMode = presentingViewController is UINavigationController
        
     //   if isPresentingInAddPlayerMode {
    //        dismiss(animated: true, completion: nil)
    //    } else if let owningNavigationController = navigationController{
    //        owningNavigationController.popViewController(animated: true)
    //    } else {
    //        fatalError("The RatingController is not inside a navigation controller.")
    //    }
    //}
}
