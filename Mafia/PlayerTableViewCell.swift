//
//  PlayerTableViewCell.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 13.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    // MARK: - Элементы управления ячейкой
    
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var healButton: UIButton!
    @IBOutlet weak var killButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var silenceButton: UIButton!
    @IBOutlet weak var setRoleButton: UIButton!

    // MARK: - События ячейки
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Конфигурируем сотояние выбранной ячейки
    }

}
