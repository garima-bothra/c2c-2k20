//
//  AgendaTableViewCell.swift
//  c2c
//
//  Created by Tushar Singh on 17/03/19.
//  Copyright © 2019 Tushar Singh. All rights reserved.
//

import UIKit

class AgendaTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var imageType: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomView.backgroundColor = UIColor.acmGreen()
        bottomView.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
       // self.bottomView.isHidden = true
        dateLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
