import UIKit

class FAQsVC: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var FAQTableView: UITableView!
    var questionArr = [String]()
    var AnswerArr = [String]()
    // @IBOutlet weak var notification: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        get()
        FAQTableView.backgroundColor = .clear
        FAQTableView.separatorStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        menuIcon.isUserInteractionEnabled = true
        menuIcon.addGestureRecognizer(tapGesture)
        bottomView.backgroundColor = UIColor.acmGreen()
        FAQTableView.dataSource = self as? UITableViewDataSource
        FAQTableView.delegate = self as? UITableViewDelegate
 //bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    //    let ges = UITapGestureRecognizer(target: self, action: #selector(tap))
    //    notification.isUserInteractionEnabled = true
    //    notification.addGestureRecognizer(ges)
    }
  
    
    
    @objc func handleTap() {
        let childVC = storyboard!.instantiateViewController(withIdentifier: "BottomMenu")
        let segue = BottomCardSegue(identifier: nil, source: self, destination: childVC)
        prepare(for: segue, sender: nil)
        segue.perform()
        
    }
func get()
{
  questionArr = ["How do I submit my work?","Who will own the Intellectual Property Rights of the product developed by my team?","How many reviews will be there?","What is the weightage of each review","Will I get food?","What do I do if I want to rest?","Who is on the Judging Panel?","Can we work on our own problem statements?","What do I do if I need an internet connection?","What will we be judging criterion?","Who do I contact if I face any problems?"]
  AnswerArr = ["You can submit your ideas on the portal. Further details will be shared.","The Intellectual Property Rights belong solely to your team.","There will be two reviews.","There will be elimination after review 2 on 8th and another elimination round on 9th.","Yes you will get loads of yummy food to fill your bellies with!","You can relax in CS Hall and participate in one of the many fun activities to refresh your mind.","Judging panel will comprise of industry experts","Of course! As long as your problem statement is relevant to one of the tracks provided.","You will be provided with free access to our beloved internet facility, VOLSBB.","The criterion for evaluations are: Simplicity, Design, Solution to real time problem, Technology and Feasibility as a product.","You can call anyone from the organizing team. We will be happy to help!"]
    self.FAQTableView.reloadData()
}
}

extension FAQsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = FAQTableView.dequeueReusableCell(withIdentifier: "faqs") as! QuestionViewCell
    cell.isUserInteractionEnabled = false
        cell.questionLabel.textColor = .white
        cell.answerLabel.textColor = .white
        cell.questionLabel.text = questionArr[indexPath.section]
        cell.answerLabel.text = AnswerArr[indexPath.section]
    return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }

}
@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
