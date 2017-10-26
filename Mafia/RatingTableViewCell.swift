//
//  RatingTableViewCell.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 22.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {

    // MARK: - Элементы управления ячейкой
    @IBOutlet weak var iconPeople: UIImageView!
    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var dottedLine: DottedLineView!
    
    // MARK: - События ячейки

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
