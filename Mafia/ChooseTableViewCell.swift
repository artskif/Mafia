//
//  ChooseTableViewCell.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 24.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class ChooseTableViewCell: UITableViewCell {
    
    // MARK: - Элементы управления ячейкой
    
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var chooseButton: UIButton!

    // MARK: - События ячейки
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Конфигурируем сотояние выбранной ячейки
    }

}
