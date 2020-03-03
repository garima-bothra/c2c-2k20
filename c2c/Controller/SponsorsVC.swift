import UIKit
import Firebase
import SwiftyJSON
import Kingfisher
class SponsorsVC: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuIcon: UIImageView!
 //   @IBOutlet weak var notification: UIImageView!
    @IBOutlet weak var contentTableView: UITableView!
    
    var imageArr = [URL]()
    var json = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        activityindicator.center = self.view.center
        activityindicator.hidesWhenStopped = true
        activityindicator.style = UIActivityIndicatorView.Style.whiteLarge
        self.view.addSubview(activityindicator)
        activityindicator.startAnimating()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        menuIcon.isUserInteractionEnabled = true
        menuIcon.addGestureRecognizer(tapGesture)
        bottomView.backgroundColor = UIColor.acmGreen()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.backgroundColor = .clear
        contentTableView.separatorStyle = .none
   //     let ges = UITapGestureRecognizer(target: self, action: #selector(tap))
        get()
    }
  
    func get(){
        let ref = Database.database().reference().child("sponsors")
        ref.observe(.value) { (data) in
            let value = data.value as? NSDictionary
            for key in value!.allKeys {
                self.imageArr.append(URL(string:value![key] as! String)!)
            }
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

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension SponsorsVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return imageArr.count

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(withIdentifier: "sponsor") as! SponsorTableViewCell
        cell.sponsor.kf.setImage(with: imageArr[indexPath.section])
        cell.backgroundColor = .clear
        cell.isUserInteractionEnabled = false
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
//        v.frame = CGRect(x: 0, y: 0, width: contentTableView.frame.width, height: 150)
        return v
    }
    
}
