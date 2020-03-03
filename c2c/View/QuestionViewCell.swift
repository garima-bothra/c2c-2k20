import UIKit

class QuestionViewCell : UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.layer.cornerRadius = 10
    self.backgroundColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
       
        self.answerLabel.textColor = .white
        self.questionLabel.textColor = .white
        self.answerLabel.layer.borderWidth = 1.0
        self.answerLabel.layer.cornerRadius = 10
        // self.answerLabel.backgroundColor = .black
        self.answerLabel.layer.borderColor = UIColor.acmGreen().cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
}

