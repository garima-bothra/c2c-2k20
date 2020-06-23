//
//  SponsorTableViewCell.swift
//  c2c
//
//  Created by Tushar Singh on 20/03/19.
//  Copyright © 2019 Tushar Singh. All rights reserved.
//

import UIKit

class SponsorTableViewCell: UITableViewCell {

    @IBOutlet weak var sponsor: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
