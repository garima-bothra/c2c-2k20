
import UIKit

class someThingWrongVC: UIViewController {

   
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var adminPassword: UITextField!
    @IBOutlet weak var goToFoodScreen: UIButton!
    
    @IBOutlet weak var BypassKey: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.textColor = .white
        goToFoodScreen.setTitleColor(.white, for: .normal)
        adminPassword.layer.borderWidth = 2.0
        BypassKey.layer.borderWidth = 2.0
        adminPassword.layer.borderColor = UIColor.acmGreen().cgColor
        BypassKey.layer.borderColor = UIColor.acmGreen().cgColor
        adminPassword.attributedPlaceholder = NSAttributedString(string: "Admin Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 236/270, green: 240/270, blue: 241/270, alpha: 1.0)])
        BypassKey.attributedPlaceholder = NSAttributedString(string: "Bypass Key", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 236/270, green: 240/270, blue: 241/270, alpha: 1.0)])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func adminBypassAdd(_ sender: Any) {
        if(adminPassword.text == "syklops") {
            tokenRecieved = BypassKey.text ?? ""
            validateToken(viewController: self)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Incorrect Admin Bypass Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
