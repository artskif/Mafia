//
//  GameRatingTableViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 28.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

// Таблица рейтинга текущей игры
class GameRatingTableViewController: UITableViewController {

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
        return 1
    }
    
    // Кличесто элементов в одной секции таблицы
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.countPlayers()
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameRatingTableViewCell", for: indexPath) as? RatingTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GameRatingTableViewCell.")
        }
        
        // Какие данные будем использовать для текущей обрабатываемой ячейки
        let player = game.getPlayer(at: indexPath.row)
        let sum = player.currentRating.reduce(0, { x, y in x + y})
        
        cell.nameLabel.text = player.name
        cell.ratingLabel.text = "\(sum < 1 ? 1 : sum)"
        cell.numberLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    // Определяем возможность редактировать таблицу участников
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Обработка действий пользователя
    
    @IBAction func pushCancelButton(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresenting = presentingViewController is UINavigationController
        
        if isPresenting {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The GameRatingController is not inside a navigation controller.")
        }
    }
    
}
