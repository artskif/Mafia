//
//  PopupViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 28.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var textMessageLabel: UILabel!
    
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
    }
}
