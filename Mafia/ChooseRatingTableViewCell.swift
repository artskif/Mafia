//
//  ChooseRatingTableViewCell.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 19.05.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class ChooseRatingTableViewCell: UITableViewCell {

    // MARK: - Элементы управления ячейкой
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    
    
    // MARK: - События ячейки

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
