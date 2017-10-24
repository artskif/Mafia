//
//  FromMainPropertiesController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 24.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class FromMainPropertiesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navbar_bg_dark"), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
