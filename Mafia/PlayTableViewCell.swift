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
    
    // MARK: - События ячейки
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Конфигурируем сотояние выбранной ячейки
    }
}
