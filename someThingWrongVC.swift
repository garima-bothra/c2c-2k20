
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
        if(adminPassword.text == "devanshi") {
            tokenRecieved = BypassKey.text ?? ""
            print(tokenRecieved)
         let alerts = validateToken()
         if(alerts == "ok") || (alerts == "redeemed"){
            let alert = UIAlertController(title: "Response", message: response, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "goToFood", sender: Any.self)
         }
         else if(alerts == "callget"){
            let alert = UIAlertController(title: "Response", message: response, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "goToFood", sender: Any.self)
            }
        }
        else
        {
               let alert = UIAlertController(title: "Response", message: "Invalid admin!", preferredStyle: UIAlertController.Style.alert)
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
