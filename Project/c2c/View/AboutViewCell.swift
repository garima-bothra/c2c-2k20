//
//  AboutViewCell.swift
//  c2c
//
//  Created by Garima Bothra on 01/03/20.
//  Copyright © 2020 Tushar Singh. All rights reserved.
//

import UIKit

class AboutViewCell : UITableViewCell
{
    override func awakeFromNib() {
    super.awakeFromNib()
    }
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
           self.layer.cornerRadius = 10
           self.backgroundColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        heading.textColor = .white
        bodyText.textColor = .white
           // Configure the view for the selected state
       }
}
