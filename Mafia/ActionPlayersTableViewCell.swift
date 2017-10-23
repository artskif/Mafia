//
//  ActionPlayersTableViewCell.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 17.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class ActionPlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var roleImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var choosedImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
