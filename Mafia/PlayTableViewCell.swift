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
    @IBOutlet weak var roleImage: UIImageView!
    @IBOutlet weak var currentRating: UILabel!
    @IBOutlet weak var choosedImage: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var ripLabel: UILabel!
    @IBOutlet weak var killButton: UIButton!
    @IBOutlet weak var dottedLine: DottedLineView!
    
    // MARK: - События ячейки
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
