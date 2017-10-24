//
//  ActionsTableViewCell.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 12.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class ActionsTableViewCell: UITableViewCell {

    // MARK: - Элементы управления ячейкой
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleImage: UIImageView!
    @IBOutlet weak var chooseButton: UILabel!
    @IBOutlet weak var choosedLabel: UIImageView!
    @IBOutlet weak var dottedLine: DottedLineView!
    
    // MARK: - События ячейки
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Конфигурируем сотояние выбранной ячейки
    }
}
