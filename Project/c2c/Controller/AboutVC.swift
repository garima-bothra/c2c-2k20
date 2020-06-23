import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var contentTableView: UITableView!
    
    var heading : [String] = [String()]
    var sectionText : [String] = [String()]
    override func viewDidLoad() {
        super.viewDidLoad()
        get()
        contentTableView.backgroundColor = .clear
        contentTableView.separatorStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        menuIcon.isUserInteractionEnabled = true
        
    menuIcon.addGestureRecognizer(tapGesture)
        bottomView.backgroundColor = UIColor.acmGreen()
      //  let ges = UITapGestureRecognizer(target: self, action: #selector(tap))
        contentTableView.delegate = self as? UITableViewDelegate
        contentTableView.dataSource = self as? UITableViewDataSource
    }
   
    @objc func handleTap() {
        let childVC = storyboard!.instantiateViewController(withIdentifier: "BottomMenu")
        let segue = BottomCardSegue(identifier: nil, source: self, destination: childVC)
        prepare(for: segue, sender: nil)
        segue.perform()
        
    }
    func get()
    {
         heading = ["ACM","C2C"]
         sectionText = ["Code2Create is ACM-VIT’s flagship event and one of the grandest annual events hosted in VIT. A thrilling tech sprint awaited by numerous innovators, Code2Create witnesses a plethora of skill sets. Code2Create is a place where graphic designers, software developers, app and web developers collaborate intensively on projects. Participants from across the country indulge in 36 hours of intense brainstorming, designing, creating and testing, along with some engaging and very enjoyable side quests.","Right from its inception in 2009, the ACM VIT Student Chapter has been organizing and conducting successful technical and professional development events. ACM-VIT is a non-profit organization of talented individuals specialising in several domains of technology like WebDev, AppDev, Machine Learning, AR/VR, CyberSec and many more. Technology is its cause and education its objective, which we achieve by conducting exciting and informative events all year round with Code2Create being our grandest event."]
        self.contentTableView.reloadData()
    }
}

extension AboutVC : UITableViewDelegate, UITableViewDataSource{
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return heading.count
       }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = contentTableView.dequeueReusableCell(withIdentifier: "about") as! AboutViewCell
        cell.isUserInteractionEnabled = false
        cell.heading.text = heading[indexPath.section]
        cell.bodyText.text = sectionText[indexPath.section]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 313
    }
}
