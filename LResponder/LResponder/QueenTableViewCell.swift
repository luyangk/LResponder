//
//  QueenTableViewCell.swift
//  LResponder
//
//  Created by Lucca Lu on 2018/8/21.
//  Copyright © 2018 Lucca Lu. All rights reserved.
//

import UIKit

class QueenTableViewCell: UITableViewCell {
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var usedTimeLabel: UILabel!
    @IBOutlet weak var seqLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor = .white
        self.layer.borderColor = borderColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
