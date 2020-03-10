
import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
          
    
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        currentUser =  UserDefaults.standard.string(forKey: "current") ?? ""
        let islogin = UserDefaults.standard.bool(forKey: "status")
        if islogin{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let exampleViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Agenda") as! AgendaVC
            self.window?.rootViewController = exampleViewController
            self.window?.makeKeyAndVisible()
        }else{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let exampleViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Login") as! ViewController
            self.window?.rootViewController = exampleViewController
            
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    // MARK: GIDSignInProtocolFunctions
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        print(error)
        return
      }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            print("Sign in error")
            print(error)
            return
          }
           let email = Auth.auth().currentUser?.email
                   let uid = Auth.auth().currentUser?.uid
                   activityindicator.center = (self.window?.rootViewController?.view.center)!
                   activityindicator.hidesWhenStopped = true
                   activityindicator.style = UIActivityIndicatorView.Style.whiteLarge
                    self.window?.rootViewController?.view.addSubview(activityindicator)
                   activityindicator.startAnimating()
                   var regmail : String = String()
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   var viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "Agenda") as! UIViewController
                   let refRegistered = Database.database().reference().child("registeredEmails")
//            refRegistered.queryLimited(toLast: 1).observeSingleEvent(of: .value){
//                (myDataSnap) in
//                let value = myDataSnap.value as? DataSnapshot
//                print("LASTTT")
//                print(value)
            
            refRegistered.observe(.value) { (snapshot) in
                    
                       for child in snapshot.children.allObjects as! [DataSnapshot] {
                         //  print(child.value)
                           regmail = child.value! as! String
                           if(regmail == email){
                               userDefaults.setValue(uid, forKey: "current")
                               userDefaults.setValue(true, forKey: "status")
                   let viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "Agenda") as! UIViewController
                               if( uid != nil){
                                   Database.database().reference().child("users").child(uid!).setValue(email)
                                activityindicator.stopAnimating()
                                   self.window?.rootViewController = viewController
                               }
                               break
                           }
                       }
                 userStatus =
                if ( UserDefaults.standard.string(forKey: "status") == "false"){
                           let alert = UIAlertController(title: "Sign Up Fail", message: "Contact an organizer. You do not seem to be registered.", preferredStyle: UIAlertController.Style.alert)
                        activityindicator.stopAnimating()
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.window?.rootViewController?.view
                            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                       }

                    
                   }

               }
           }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

func validateToken( viewController : UIViewController )  {
    var message = ""
     if tokenRecieved != "" &&  currentT != ""{
        if( token != ""){
            if(token == tokenRecieved){
                let attRef = Database.database().reference().child("scannables").child("attendances").child(currentT).child("couponUidList")
                attRef.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists(){
                        message = "The coupon is already reedeemed."
                        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        viewController.present(alert, animated: true, completion: nil)
                    }else{
                        attRef.child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser!.email)
                        reedeemedArr.append(token)
                        message = "Successfully Reedeemed Coupon."
                        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        viewController.present(alert, animated: true, completion: nil)
                    }
                })
            }
            else
            {
                message = "The coupon and coupon key do not match."
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            message = "Select a coupon to reedeem."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
     }
     else if(tokenRecieved == ""){
        message = "Enter a valid coupon key."
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
        }
     else{
        message = "Coupon already reedeemed."
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    }
