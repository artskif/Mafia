//
//  PlayTableViewCell.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 12.05.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

@IBDesignable class PlayTableViewCell: UITableViewCell {

    // MARK: - Элементы управления ячейкой
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLaber: UILabel!
    @IBOutlet weak var healButton: UIButton!
    @IBOutlet weak var killButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var silenceButton: UIButton!
    @IBOutlet weak var maniacButton: UIButton!
    @IBOutlet weak var donmaffiaButton: UIButton!
    @IBOutlet weak var roleImage: UIImageView!
    @IBOutlet weak var killImage: UIImageView!
    @IBOutlet weak var yacuzaButton: UIButton!
    @IBOutlet weak var lawerButton: UIButton!
    
    
    @IBOutlet weak var currentRating: UILabel!
    @IBOutlet weak var globalRating: UILabel!
    
    // MARK: - События ячейки
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Конфигурируем сотояние выбранной ячейки
    }
}
