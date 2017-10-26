//
//  PopupViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 28.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

//
//  Модальное окно вывода сообщений
//
class PopupViewController: UIViewController {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closePopup(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    // MARK: - Анимация контроллера
    
    // Показать модульное окно на экране
    func showAnimate() {
        self.view.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1
        })
    }
    
    // Удалить модульное окно с экрана
    func removeAnimate() {
        UIView.animate(withDuration: 0.2, animations: {self.view.alpha = 0}, completion: {(finished:Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        })
        
        if game.isFinished {
            // Заканчиваем игру если выставлен флаг окончания игры
            let alert = UIAlertController(title: "Завершение игры", message: "Хотите сохранить рейтинг?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: { (action) in
                game.saveRating()
                self.performSegue(withIdentifier: "backToMain", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.default, handler: { (action) in
                self.performSegue(withIdentifier: "backToMain", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
