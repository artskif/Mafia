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
        
        // Делаем навигационную панель прозрачной
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Обработка действий пользователя
    
    @IBAction func startNewGame(_ sender: Any) {
        game = Game() // Стартуем!
        self.performSegue(withIdentifier: "newGame", sender: self)
    }

    // Нажали Cancel в таблице рейтинга пользователей
    @IBAction func unwindCancelToMainScreen(sender: UIStoryboardSegue) {
    }
}

