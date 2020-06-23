//
//  AlertCell.swift
//  
//
//  Created by Tushar Singh on 14/03/19.
//

import UIKit

class AlertCell: UITableViewCell {

    @IBOutlet weak var notificationHeading: UILabel!
    @IBOutlet weak var notificationBody: UITextView!
    
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationHeading.textColor = UIColor.acmGreen()
        self.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        notificationBody.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.75)
        timeLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.75)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
