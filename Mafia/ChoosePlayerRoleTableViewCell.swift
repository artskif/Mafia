//
//  ChoosePlayerRoleTableViewCell.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 12.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class ChoosePlayerRoleTableViewCell: UITableViewCell {

    // MARK: - Элементы управления ячейкой
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleImage: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    
    // MARK: - События ячейки
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
