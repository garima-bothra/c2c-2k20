import UIKit
import Firebase
import SwiftyJSON
class AgendaVC: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var contentTableView: UITableView!
    var agendaArray : [Agenda] = [Agenda]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityindicator.center = self.view.center
        activityindicator.hidesWhenStopped = true
        activityindicator.style = UIActivityIndicatorView.Style.whiteLarge
        self.view.addSubview(activityindicator)
        activityindicator.startAnimating()
        userDefaults.setValue(true, forKey: "status")
        get()
        contentTableView.backgroundColor = .clear
        contentTableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
       // let ges = UITapGestureRecognizer(target: self, action: #selector(tap))
        menuIcon.isUserInteractionEnabled = true
        menuIcon.addGestureRecognizer(tapGesture)
        bottomView.backgroundColor = UIColor.acmGreen()
        //bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
    }
 
    func get(){
        let ref = Database.database().reference().child("agendas").child("agendasList")
        ref.observe(.value) { (data) in
            let json = JSON(data.value)
            
            for i in 0...json.count{
               var agenda = Agenda()
               agenda.title  = json[i]["agendaTitle"].stringValue
               agenda.startTime  = json[i]["startTime"].stringValue
               agenda.finishTime  = json[i]["endTime"].stringValue
               agenda.imageType = json[i]["type"].stringValue
                self.agendaArray.append(agenda)
        }
          //  print("Count",self.agendaArray.count)
         self.contentTableView.reloadData()
            activityindicator.stopAnimating()
        }
    }
    

    @objc func handleTap() {
        let childVC = storyboard!.instantiateViewController(withIdentifier: "BottomMenu")
        let segue = BottomCardSegue(identifier: nil, source: self, destination: childVC)
        prepare(for: segue, sender: nil)
        segue.perform()
        
    }

    
}

extension AgendaVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return agendaArray.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(withIdentifier: "agenda") as! AgendaTableViewCell
        cell.isUserInteractionEnabled = false
        
        if agendaArray[indexPath.section].imageType == "talk"{
            cell.imageType.image = UIImage(named: "twotone-mic-24px")
            
        }
        else if agendaArray[indexPath.section].imageType == "food"{
            cell.imageType.image = UIImage(named: "lunch")
            
        }else{
            cell.imageType.image = UIImage(named: "AboutWhite")
        }
        
        cell.timingLabel.textColor = .white
        cell.typeLabel.textColor = .white
        cell.typeLabel.text = agendaArray[indexPath.section].title
        cell.timingLabel.text = agendaArray[indexPath.section].startTime+" - "+agendaArray[indexPath.section].finishTime
        cell.dateLabel.text = agendaArray[indexPath.section].date
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
