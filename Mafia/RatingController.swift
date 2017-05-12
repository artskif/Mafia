//
//  RatingController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 22.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class RatingController: UITableViewController {
    
    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!

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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Кличесто элементов в одной секции таблицы
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.accounts.count
    }

    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RatingViewCell", for: indexPath) as? RatingTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RatingViewCell.")
        }
        
        // Какие данные будем использовать для текущей обрабатываемой ячейки
        let account = game.accounts[indexPath.row]
        
        cell.nameLabel.text = account.name
        cell.ratingLabel.text = "\(account.rating)"
        cell.numberLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }

    // Определяем возможность редактировать таблицу участников
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Обработка действий пользователя
    
    @IBAction func cancelTab(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddPlayerMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPlayerMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The RatingController is not inside a navigation controller.")
        }
    }
}
