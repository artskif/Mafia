//
//  MenuGlobalRatingViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 19.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class MenuGlobalRatingViewController: UIViewController {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Настраиваем кнопку меню
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navbar_bg_dark"), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
