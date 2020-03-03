
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
        var islogin = UserDefaults.standard.bool(forKey: "status")
        if islogin{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var exampleViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Agenda") as! AgendaVC
            
            self.window?.rootViewController = exampleViewController
            self.window?.makeKeyAndVisible()
        }else{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var exampleViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Login") as! ViewController
            
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
            var regmail : String = String()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            var viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "Agenda") as! UIViewController
            let refRegistered = Database.database().reference().child("registeredEmails")
            refRegistered.observe(.value) { (snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                  //  print(child.value)
                    regmail = child.value! as! String
                    if(regmail == email){
                        userDefaults.setValue(uid, forKey: "current")
                        userDefaults.setValue(true, forKey: "status")
                        if( uid != nil){
                            Database.database().reference().child("users").child(uid!).setValue(email)
                           
                            var exampleViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "Agenda") as! AgendaVC
                            self.window?.rootViewController = viewController
                        }
                        break
                    }
                }
                if (self.window?.rootViewController != viewController){
                    let alert = UIAlertController(title: "Sign Up Fail", message: "Contact an organizer. You do not seem to be registered.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
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

func validateToken() -> String{
    if(currentUser == ""){
        currentUser = Auth.auth().currentUser?.uid ?? "fail"
    }
//        print(tokenRecieved)
//              print(token)
//              print(currentT)
         if tokenRecieved != "" && token != "" && currentT != ""{
//            print(tokenRecieved)
//           print(token)
//           print(currentT)
            if(attendance[currentT] == nil){
                
            if(token == tokenRecieved){
                status="callget"
                response = "Sucessfully Redeemed"
                let ref = Database.database().reference().child("scannables").child("attendance").child(currentT).child("couponsUserList").child("0")
                 currentUser = Auth.auth().currentUser?.uid ?? "fail"
                ref.setValue(currentUser)
               // attendance[currentT] : [currentUser]
            }
            else {
                status="redeemed"
                response = "Wrong Token"
                }
            }
            else
            {
             for i in 0...attendance[currentT]!.count-1{
                 if currentUser != attendance[currentT]![i] && tokenRecieved==token{
                     status="ok"
                     response = "Sucessfully Redeemed"
                     reedeemedArr.append(token)
                       break
                 }
                 else{
                     status="redeemed"
                     response = "Item Already Redeemed or Wrong Token"
                 }
             }
            
             if status == "ok"{
                
                 currentUser = Auth.auth().currentUser?.uid ?? "fail"
                 attendance[currentT]!.append(currentUser)
                 let ref = Database.database().reference().child("scannables").child("attendance").child(currentT).child("couponsUserList")
                    reedeemedArr.append(token)
                 ref.setValue(attendance[currentT])
                 attendance.removeAll()
                 userArr.removeAll()
                 timingArrEnd.removeAll()
                 timingArrStart.removeAll()
                 itemList.removeAll()
                 tokenArr.removeAll()
                 date.removeAll()
                 typeArr.removeAll()
                }
            }
         }
       return status
     }
 
