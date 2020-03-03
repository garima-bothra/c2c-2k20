
import UIKit
import Firebase

class BottomMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var contentTable: UITableView!
    
    var labelArr = ["Agenda","Prizes","Food Coupons","Sponsors","About","FAQs","Logout"]
    var whiteImages = ["heartWhite","trophyWhite","couponsWhite","SponsorsWhite","AboutWhite","question","logoutWhite"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.backgroundColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        contentTable.separatorStyle = .none
        // Do any additional setup after loading the view.

    }
    

 

    @IBAction func downButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        var a = PrizesVC()
    }
}

extension BottomMenuVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BottomTableCell
        cell.typeLabel.text = labelArr[indexPath.row]
        cell.typeLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.75)
        cell.typeImage.image = UIImage(named: whiteImages[indexPath.row])
        cell.backgroundColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = tableView.cellForRow(at: indexPath) as! BottomTableCell
        cell.typeLabel.textColor = UIColor.acmGreen()
       // print(cell.typeLabel.text)
        if cell.typeLabel.text != "Logout"{
            
            let vc = storyboard!.instantiateViewController(withIdentifier: cell.typeLabel.text!)
             present(vc, animated: true, completion: nil)
            
        }else{
            let vc = storyboard!.instantiateViewController(withIdentifier: "Login")
            let def = UserDefaults.standard
            def.set(false, forKey: "status")
            userDefaults.setValue(false, forKey: "status")
             let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                 present(vc, animated: true, completion: nil)
            } catch let signOutError as NSError {
             // print ("Error signing out: %@", signOutError)
            let alert = UIAlertController(title: "Logout Failed", message: "Try logging out again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            }
              
            
        }
       
        
    }
}
