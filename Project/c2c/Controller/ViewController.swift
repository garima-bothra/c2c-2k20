import UIKit
import Firebase
import GoogleSignIn
import SwiftyJSON

var currentUser = String()

var handle: AuthStateDidChangeListenerHandle?
var activityindicator = UIActivityIndicatorView()
class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleSinginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    let viewTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    func acmGreen() -> UIColor{
        return UIColor(red: 57/255, green: 199/257, blue: 157/255, alpha: 1)
    }    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 57/255, green: 199/257, blue: 157/255, alpha: 1).cgColor
        emailTextField.textColor = .white
        passwordTextField.textColor = .white
        emailTextField.frame.size.height = 45
        emailTextField.layer.cornerRadius = 23
        emailTextField.layer.masksToBounds = true
        emailTextField.placeholder = "Email"
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 57/255, green: 199/257, blue: 157/255, alpha: 1).cgColor
        passwordTextField.layer.cornerRadius = 23
        passwordTextField.frame.size.height = 45
        passwordTextField.layer.masksToBounds = true
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 23
        googleSinginButton.layer.cornerRadius = 23
        passwordTextField.clearsOnInsertion = false
        emailTextField.clearsOnInsertion = false
        emailTextField .attributedPlaceholder = NSAttributedString(string: "Email ID", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 236/270, green: 240/270, blue: 241/270, alpha: 1.0)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 236/270, green: 240/270, blue: 241/270, alpha: 1.0)])
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 17),
        .foregroundColor: UIColor.white,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Not yet registered? Signup here",
                                                            attributes: yourAttributes)
            signupButton.setAttributedTitle(attributeString, for: .normal)
         GIDSignIn.sharedInstance()?.presentingViewController = self
         
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    let defaults = UserDefaults.standard
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        var isLogged = false
        if emailTextField.text != "",passwordTextField.text != ""{
                  let email = emailTextField.text!
                  let password = passwordTextField.text!
                  Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                       if (error != nil) {
                            let message = handleError(error: error!)
                            let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            guard let strongSelf = self else { return }
                                    strongSelf.present(alert, animated: true, completion: nil)
                                }
                            else{
                                guard let user = Auth.auth().currentUser else { return }
                                user.reload { (error) in
                                var message = String()
                                guard let strongSelf = self else { return }
                                switch user.isEmailVerified {
                                    case true:
                                    userDefaults.setValue(true, forKey: "status")
                                    let current_userid = Auth.auth().currentUser?.uid
                                    userDefaults.setValue(current_userid, forKey: "current")
                                    if(current_userid != nil){
                                    Database.database().reference().child("users").child(current_userid!).setValue(email)
                                    }
                                    isLogged = true
                                    strongSelf.performSegue(withIdentifier:"loginToAgenda" , sender: Any.self)
                                   case false:
                                    let alert = UIAlertController(title: "Login Unsuccessful", message: "You do not seem to have verified your email. Do you want us to send verification email again?", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: strongSelf.sendVerification))
                                    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
                                    strongSelf.present(alert, animated: true, completion: nil)
                                   }
                                   }
                                }
                             }
    }
    }
    
    @IBAction func signupScreenButton(_ sender: Any) {
        performSegue(withIdentifier: "signupsegue", sender: Any.self)
    }
    @IBAction func googleSigninButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sendVerification(action : UIAlertAction){
        guard let user = Auth.auth().currentUser else { return }
        var message = String()
        user.sendEmailVerification { (error) in
        guard let error = error else{
           message = "User email verification is sent again on your mail again."
          let alert = UIAlertController(title: "Verify your mail", message: message, preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
         return
        }
        message = handleError(error: error)
        let alert = UIAlertController(title: "Could not send mail", message:"Verification mail is not sent. \(message)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIColor{
    class func acmGreen() -> UIColor{
        return UIColor(red: 57/255, green: 199/257, blue: 157/255, alpha: 1)
    }
}

func handleError(error: Error)-> String
{
    var response = String()
    let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
    switch errorAuthStatus {
    case .wrongPassword:
        response = "Wrong password"
        return response
    case .invalidEmail:
        response = "Invalid Email"
        return response
    case .operationNotAllowed:
        response = "Operation not allowed"
        return response
    case .userDisabled:
        response = "User disabled"
        return response
    case .userNotFound:
        response = "User not found"
        return response
    case .tooManyRequests:
        response = "Too many requests"
        return response
    case .emailAlreadyInUse:
        response = "Email already in use"
        return response
    case .weakPassword:
        response = "Weak password! Try again with a strong password"
        return response
    default:
        response = "Invalid credentials"
        return response
}
}
