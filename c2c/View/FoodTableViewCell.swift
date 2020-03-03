//
//  FoodTableViewCell.swift
//  c2c
//
//  Created by Tushar Singh on 15/03/19.
//  Copyright © 2019 Tushar Singh. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sideView: UIView!
    
    var currentT = String()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sideView.backgroundColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
        statusLabel.textColor = UIColor(red: 77/255, green: 74/255, blue: 74/255, alpha: 1)
        statusLabel.text = ""
        typeLabel.text=" "
        timingLabel.text=" "
        statusLabel.text=" "
        sideView.backgroundColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
        isUserInteractionEnabled = true

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.statusLabel.transform = CGAffineTransform(rotationAngle: .pi/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
