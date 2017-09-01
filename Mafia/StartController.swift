//
//  ViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 10.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

//
//  Стартовый контроллер, экран меню (Новая игра, Рейтинг)
//
class StartController: UIViewController {
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Обработка действий пользователя
    
    // Нажали Cancel в таблице рейтинга пользователей
    @IBAction func unwindCancelToMainScreen(sender: UIStoryboardSegue) {
    }
}

