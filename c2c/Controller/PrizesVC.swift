import UIKit

class PrizesVC: UIViewController {

   
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var contentTableView: UITableView!
    var ctr = 0
    var prizeList = [Prize]()
    var prize1 = Prize()
    var prize2 = Prize()
    var prize3 = Prize()
    var prize4 = Prize()
    var prize5 = Prize()
    var prize6 = Prize()
    
    func get()
    {
        prize1.img = "gold-medal"
        prize1.prizeName = "First"
        prize1.prizeAmount = "₹35,000"
        prizeList.append(prize1)
        prize2.img = "gold-medal-1"
        prize2.prizeName = "Second"
        prize2.prizeAmount = "₹15,000"
        prizeList.append(prize2)
        prize3.img = "gold-medal-2"
        prize3.prizeName = "Third"
        prize3.prizeAmount = "₹8,000"
        prizeList.append(prize3)
        prize4.img = "ux-design"
        prize4.prizeName = "Best UI/UX"
        prize4.prizeAmount = "₹3000"
        prizeList.append(prize4)
        prize5.img = "ux-design"
        prize5.prizeName = "Most innovative solution"
        prize5.prizeAmount = "₹2000"
        prizeList.append(prize5)
        prize6.img = "ux-design"
        prize6.prizeName = "Best first year team"
        prize6.prizeAmount = "₹2000"
        prizeList.append(prize6)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        get()
        contentTableView.backgroundColor = .clear
        contentTableView.separatorStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        menuIcon.isUserInteractionEnabled = true
        menuIcon.addGestureRecognizer(tapGesture)
        prizeLabel.textColor = .white
        bottomView.backgroundColor = UIColor.acmGreen()
    }
   
    @objc func handleTap() {
        let childVC = storyboard!.instantiateViewController(withIdentifier: "BottomMenu")
        let segue = BottomCardSegue(identifier: nil, source: self, destination: childVC)
        prepare(for: segue, sender: nil)
        segue.perform()
        
    }
  
}

extension PrizesVC:UITableViewDelegate,UITableViewDataSource{

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
    
}

func numberOfSections(in tableView: UITableView) -> Int {
    return prizeList.count 
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = contentTableView.dequeueReusableCell(withIdentifier: "prize") as! PrizeViewCell
    cell.isUserInteractionEnabled = false
    cell.prizeNameLabel.textColor = .white
    cell.prizeMoneyLabel.textColor = .white
    cell.prizeMoneyLabel.text = prizeList[indexPath.section].prizeAmount
    cell.prizeNameLabel.text = prizeList[indexPath.section].prizeName
    cell.prizeImageType.image = UIImage(named: prizeList[indexPath.section].img)
    return cell
}
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let v = UIView()
           v.backgroundColor = .clear
           return v
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 100
      }
    
}
