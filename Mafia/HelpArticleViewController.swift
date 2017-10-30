//
//  HelpArticleViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 30.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class HelpArticleViewController: UIViewController {

    var choosedHelp: HelpArticles = .Game
    @IBOutlet weak var articleText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleText.text = choosedHelp.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
