import UIKit
import Firebase

let userDefaults = UserDefaults.standard

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!    
    @IBOutlet weak var goToLoginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
       override func viewDidLoad() {
           super.viewDidLoad()
           //get()
           emailTextField.layer.borderWidth = 1.0
           emailTextField.layer.borderColor = UIColor(red: 57/255, green: 199/257, blue: 157/255, alpha: 1).cgColor
           emailTextField.textColor = .white
           passwordTextField.textColor = .white
           emailTextField.frame.size.height = 45
           emailTextField.layer.cornerRadius = 23
           emailTextField.layer.masksToBounds = true
           passwordTextField.layer.borderWidth = 1.0
           passwordTextField.layer.borderColor = UIColor(red: 57/255, green: 199/257, blue: 157/255, alpha: 1).cgColor
           passwordTextField.layer.cornerRadius = 23
           passwordTextField.frame.size.height = 45
           passwordTextField.layer.masksToBounds = true
           passwordTextField.isSecureTextEntry = true
           signUpButton.layer.cornerRadius = 23
           passwordTextField.clearsOnInsertion = false
           emailTextField.clearsOnInsertion = false
           emailTextField.attributedPlaceholder = NSAttributedString(string: "Email ID", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 236/270, green: 240/270, blue: 241/270, alpha: 1.0)])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 236/270, green: 240/270, blue: 241/270, alpha: 1.0)])
        
           let yourAttributes: [NSAttributedString.Key: Any] = [
           .font: UIFont.systemFont(ofSize: 17),
           .foregroundColor: UIColor.white,
           .underlineStyle: NSUnderlineStyle.single.rawValue]
           let attributeString = NSMutableAttributedString(string: "Already registered? Login here",
                                                               attributes: yourAttributes)
               goToLoginButton.setAttributedTitle(attributeString, for: .normal)
       
           
       }
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
       let defaults = UserDefaults.standard
       
    @IBAction func signUpButtonPressed(_ sender: Any) {
         if ((emailTextField.text != "") || (passwordTextField.text != "")){
            let email = emailTextField.text!
            let password = passwordTextField.text!
            activityindicator.center = self.view.center
            activityindicator.hidesWhenStopped = true
            activityindicator.style = UIActivityIndicatorView.Style.whiteLarge
            self.view.addSubview(activityindicator)
            activityindicator.startAnimating()
            let refRegistered = Database.database().reference().child("registeredEmails")
            refRegistered.observe(.value) { (snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                  //  print(child.value)
                    let regmail : String = child.value! as! String
                    if(regmail == email){
                        activityindicator.stopAnimating()
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

                         if(error != nil){
                             let message = handleError(error: error!)
                             let alert = UIAlertController(title: "Sign Up Failed", message: message, preferredStyle: UIAlertController.Style.alert)
                             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                             self.present(alert, animated: true, completion: nil)
                         }
                         else
                         {
                         guard let user = Auth.auth().currentUser else {return }
                             user.sendEmailVerification { (error) in
                                 guard let error = error else{
                                     let alert = UIAlertController(title: "Verify your mail", message: "Verification link has been sent to your mail.", preferredStyle: UIAlertController.Style.alert)
                                     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                     self.present(alert, animated: true, completion: nil)
                                     return
                                 }
                             }
                         if(user.isEmailVerified){
                         self.performSegue(withIdentifier:"signupToAgenda" , sender: Any.self)
                         userDefaults.setValue(true, forKey: "status")
                         userDefaults.setValue(Auth.auth().currentUser?.uid,forKey: "current")
                         let current_userid = Auth.auth().currentUser?.uid
                         userDefaults.setValue(current_userid, forKey: "current")
                         if(current_userid != nil){
                         Database.database().reference().child("users").child(current_userid!).setValue(email)
                         }
                         }
                         }
                        }
                        break
                    }
                }
                }
            if(activityindicator.isAnimating){
                let alert = UIAlertController(title: "Sign Up Fail", message: "Contact an organizer. You do not seem to be registered.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                activityindicator.stopAnimating()
            }
        }
         else{
            let alert = UIAlertController(title: "Sign Up Fail", message: "Use valid credentials.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func goToLoginScreenButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
   }
