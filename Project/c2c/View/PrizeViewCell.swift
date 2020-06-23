import UIKit

class PrizeViewCell: UITableViewCell {
    
   
    @IBOutlet weak var prizeImageType: UIImageView!
    
    @IBOutlet weak var prizeNameLabel: UILabel!
    @IBOutlet weak var prizeMoneyLabel: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
        self.backgroundColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        self.layer.cornerRadius = 10
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
          // Configure the view for the selected state
      }

}
