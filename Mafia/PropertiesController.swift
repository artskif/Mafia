//
//  PropertiesController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 25.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class PropertiesController: UIViewController {

    // MARK: - Свойства контроллера
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    var choosedPlayer:Player?
    var deltaRating:Int = 0
    
    // MARK: - События контроллера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sum = choosedPlayer?.currentRating.reduce(0, { x, y in x + y})
        ratingLabel.text = "\(sum ?? 0)"
        playerName.text = choosedPlayer?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func downRating(_ sender: Any) {
        deltaRating -= 1
        let sum = choosedPlayer?.currentRating.reduce(0, { x, y in x + y})
        if (sum! + deltaRating) < 0 { deltaRating += 1 }
        ratingLabel.text = "\(sum! + deltaRating)"
    }
    
    @IBAction func upRating(_ sender: Any) {
        deltaRating += 1
        let sum = choosedPlayer?.currentRating.reduce(0, { x, y in x + y})
        ratingLabel.text = "\(sum! + deltaRating)"
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindCancel", sender: self)
    }
    
    @IBAction func save(_ sender: Any) {
        if !(playerName.text?.isEmpty)! {
            choosedPlayer?.name = playerName.text!
        }
        choosedPlayer?.currentRating.append(deltaRating)
        
        self.performSegue(withIdentifier: "unwindSave", sender: self)
    }
}
