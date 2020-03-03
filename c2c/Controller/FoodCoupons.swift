var on=false

import UIKit
import ChirpSDK
import Firebase
import SwiftyJSON

var token = ""
var tokenRecieved = ""
var attendance = [String:[String]]()
var currentT = String()
var status = ""
 var response = ""
var timingArrStart = [String]()
var timingArrEnd = [String]()
var tokenArr = [String]()
var date = [String]()
var keyArr = [String]()
var typeArr = [String]()
var userArr=[String]()
var itemList = [String]()
 var reedeemedArr = [String]()
var callget = 0
class FoodCouponsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var chirpStatusLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var somethingWrong: UIButton!
  //  @IBOutlet weak var notification: UIImageView!
   
    var k = 0
    var json = JSON()
   
   
    let chirp: ChirpSDK = ChirpSDK(appKey: CHIRP_APP_KEY, andSecret: CHIRP_APP_SECRET)!
   
    var j=0
    
    var currentType=""
    var isPresent = true
   
    var userDict = [String:[String]]()
    var ip = [Int]()
    
    override func viewDidLoad() {
        if let err = chirp.setConfig(CHIRP_APP_CONFIG) {
          print("ChirpError (%@)", err.localizedDescription)
        } else {
          if let err = chirp.start() {
            print("ChirpError (%@)", err.localizedDescription)
          } else {
          //  print("Started ChirpSDK")
          }
        }
        chirp.stop()
        
        super.viewDidLoad()
        get()
        contentTableView.allowsMultipleSelection = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        menuIcon.isUserInteractionEnabled = true
        menuIcon.addGestureRecognizer(tapGesture)
        bottomView.backgroundColor = UIColor.acmGreen()
        //bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.backgroundColor = .clear
        contentTableView.separatorStyle = .none
        somethingWrong.titleLabel?.textColor = UIColor.acmGreen()
    //    let ges = UITapGestureRecognizer(target: self, action: #selector(tap))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        check()
        contentTableView.reloadData()
    }

    @objc func handleTap() {
        let childVC = storyboard!.instantiateViewController(withIdentifier: "BottomMenu")
        let segue = BottomCardSegue(identifier: nil, source: self, destination: childVC)
        prepare(for: segue, sender: nil)
        chirp.stop()
        on = false
        segue.perform()
    }
    
    
    func get(){
        attendance.removeAll()
        userArr.removeAll()
        timingArrEnd.removeAll()
        timingArrStart.removeAll()
        itemList.removeAll()
        tokenArr.removeAll()
        date.removeAll()
        typeArr.removeAll()
        let ref = Database.database().reference().child("scannables")
        ref.observe(.value) { (snap) in
            self.json = JSON(snap.value)
            for i in 0...self.json["list"]["scannableList"].count-1{
                itemList.append(self.json["list"]["scannableList"][i]["scannableTitle"].stringValue)
                timingArrStart.append(self.json["list"]["scannableList"][i]["scannableStartTime"].stringValue)
                timingArrEnd.append(self.json["list"]["scannableList"][i]["scannableEndTime"].stringValue)
                tokenArr.append(self.json["list"]["scannableList"][i]["scannableKey"].stringValue)
                date.append(self.json["list"]["scannableList"][i]["scannableDate"].stringValue)
                typeArr.append(self.json["list"]["scannableList"][i]["scannableValue"].stringValue)
                
            }
            
            for (key,_):(String,JSON) in self.json["attendance"]{
               keyArr.append(key)
               userArr.removeAll()
                let userlistsize = self.json["attendance"][key]["couponsUserList"].count
                if (userlistsize != 0){
                for i in 0...self.json["attendance"][key]["couponsUserList"].count-1{
                    userArr.append(self.json["attendance"][key]["couponsUserList"][i].stringValue)
                    attendance[key] = userArr
                }
            }
            }
            self.check()
            self.contentTableView.reloadData()
        }
    }

    func check(){
        if(attendance[keyArr[0]] != nil){
            
        for i in 0...keyArr.count-1{
            if( attendance[keyArr[i]] != nil){
                for j in 0...attendance[keyArr[i]]!.count-1{
                    if currentUser != attendance[keyArr[i]]![j]{
                        isPresent = false
                    }
                    else{
                        isPresent = true
                    }
                }
            if isPresent{
                reedeemedArr.append(keyArr[i])
            }
        }
        }
        }
    }


    @IBAction func micButton(_ sender: Any) {
        
        if(chirp.state != CHIRP_SDK_STATE_RUNNING){
            chirp.start()
            self.chirpStatusLabel.text = "Listening"
            chirp.receivedBlock = {
            (data : Data?, channel: UInt?) -> () in
            if data != nil {
                tokenRecieved = String(data: data!, encoding: .ascii) ?? ""
              //  print("Received \(tokenRecieved)")
                self.chirpStatusLabel.text = ""
                let alerts = validateToken()
                if(alerts == "callget"){
                    self.get()
                    self.check()
                    self.contentTableView.reloadData()
                    let alert = UIAlertController(title: "Response", message: response, preferredStyle: UIAlertController.Style.alert)
                                       alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                    
                }
                if(alerts == "ok") || (alerts == "redeemed"){
                    self.check()
                    self.contentTableView.reloadData()
                    let alert = UIAlertController(title: "Response", message: response, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                }
            }
        }
        else{
            self.chirpStatusLabel.text = ""
            chirp.stop()
        }

    }
    
    @IBAction func somethingWrong(_ sender: Any) {    
        performSegue(withIdentifier: "go9", sender: nil)
    }
}

extension FoodCouponsVC{
    func numberOfSections(in tableView: UITableView) -> Int {

        return itemList.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodTableViewCell
        cell.typeLabel.textColor = .white
        cell.sideView.backgroundColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
        cell.backgroundColor=UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        cell.layer.cornerRadius = 10
        cell.statusLabel.textColor = UIColor(red: 77/255, green: 74/255, blue: 74/255, alpha: 1)
        cell.timingLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.70)
        cell.selectionStyle = .none
        if json.count>0{
            cell.typeLabel.text = itemList[indexPath.section]
            cell.timingLabel.text = timingArrStart[indexPath.section]+" - "+timingArrEnd[indexPath.section]
            }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("Index",indexPath.section)
        let cell = contentTableView.cellForRow(at: indexPath) as! FoodTableViewCell
        if k==0{
            
        k+=1
        token = tokenArr[indexPath.section]
        currentType=itemList[indexPath.section]
        cell.sideView.backgroundColor = UIColor.acmGreen()
        currentT=typeArr[indexPath.section]
        cell.statusLabel.textColor = .white
        if reedeemedArr.contains(currentT){
            cell.statusLabel.text = "Redeemed"
            cell.sideView.backgroundColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
            cell.isSelected = false
            cell.isUserInteractionEnabled = false
            cell.statusLabel.textColor = UIColor(red: 77/255, green: 74/255, blue: 74/255, alpha: 1)
            currentT=""
        }
        else{
            cell.statusLabel.text = "Redeem"
            cell.statusLabel.textColor = .white
            }
            
        }else{
            k=0
            cell.sideView.backgroundColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
            cell.statusLabel.textColor = UIColor(red: 77/255, green: 74/255, blue: 74/255, alpha: 1)
            cell.statusLabel.text = ""
            currentType = ""
            token = ""
            currentT=""
            contentTableView.reloadData()
        }
       // print(currentT)

    }
    
    
}
    

let CHIRP_APP_KEY: String =  "BC9BBD9E355CA7CAF83DD408e";
let CHIRP_APP_SECRET: String = "8A9C04Ad084fBb21db1f478aE90ecCDfE3872ccFeD43A52E9b";
let CHIRP_APP_CONFIG: String = "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";

