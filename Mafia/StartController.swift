//
//  ViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 10.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class StartController: UIViewController {
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.accounts = Game.loadAccounts() // Подгружаем данные статичным методом
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Обработка действий пользователя
    
    // Нажали Cancel в таблице рейтинга пользователей
    @IBAction func unwindCancelToMainScreen(sender: UIStoryboardSegue) {
    }
}

