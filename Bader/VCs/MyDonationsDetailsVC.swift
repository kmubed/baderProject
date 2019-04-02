//
//  MyDonationsDetailsVC.swift
//  Bader
//
//  Created by AMJAD - on 29 جما١، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//


import UIKit

class MyDonationsDetailsVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var donationName: UILabel!
    @IBOutlet weak var donationImage: UIImageView!
    @IBOutlet weak var donationDatetime: UILabel!
    @IBOutlet weak var TableViewNeedyOrder: UITableView!
    
    
    
    var donation = Donations()
    var user = Users()
    var needyOrder = NeedyOrders()
    var view1 = UIView()
    var donationId = 0
    var needyList = [NeedyOrders()]
    var UserList = [Users()]

    override func viewDidLoad() {
        super.viewDidLoad()
        InitializeSpinner()
        startLoding()
        var stringDate = ""
        
        if let index = (donation.DateOfUpload ).range(of: "T")?.lowerBound {
            let substring = (donation.DateOfUpload )[..<index]
            
            stringDate = String(substring)
        }
        
        donationName.text = donation.name
        donationImage.image = self.base64Convert(base64String: self.donation.image)
        donationDatetime.text = stringDate
        getJsonFromUrl()
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        print("count return : \(needyList.count)")
        stopLoding()
        var index : Int = 0
        if UserList.count == 0 ||  needyList.count == 0{
            self.user = Users()
            user.Fname = "لا يوجد متقدمين حاليا"
            UserList.append(user)
            index = 0
        }else{
            index = UserList.count
        }
        return index
        //                return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.TableViewNeedyOrder.dequeueReusableCell(withIdentifier: "CellMyDonData", for: indexPath) as! ListNeedyCell
        
        var userCell : Users = self.UserList[indexPath.row]
        var needyCell : NeedyOrders = self.needyList[indexPath.row]
        
        var acceptStets : Bool = false
        
        if needyCell.OrderUser_status == 1
        {
            acceptStets = true
        }else{acceptStets = false}
        
        switch needyCell.OrderUser_status {
        case 1:
            acceptStets = false
  //          cell.NeedyStets.text = "تم القبول"
            cell.NeedyStets.isHidden=true
            cell.NeedyAcceptButton.isHidden = false

            break
            
        case 2:
            acceptStets = true
            cell.NeedyStets.text = "تم القبول"
            cell.NeedyStets.isHidden=false
            cell.NeedyAcceptButton.isHidden = true
            break
            
        case 3:
            cell.NeedyStets.text = "مرفوض"
            cell.NeedyStets.isHidden=false
            cell.NeedyAcceptButton.isHidden = true
            break
        default:
            cell.NeedyStets.isHidden=true
            cell.NeedyAcceptButton.isHidden = true
            break
        }
        
        cell.NeedyNames.text = userCell.Fname + " " + userCell.Lname
        cell.NeedyEmail.text = userCell.email
//        cell.NeedyStets.isHidden = acceptStets
//        cell.NeedyStets.text = (needyCell.OrderUser_status == 2) ? "تم القبول" : "تم الرفض"
        
        cell.NeedyAcceptButton.tag = indexPath.row
        cell.NeedyAcceptButton.addTarget(self, action: #selector(AcceptNeedy) , for: .touchUpInside)

        let separatorLine = UIImageView.init(frame: CGRect(x: 4, y: 0, width: cell.frame.width - 8, height: 2))
        separatorLine.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 250/255, alpha: 100)
        cell.addSubview(separatorLine)
        
        return cell
        
    }
    
    @IBAction func AcceptNeedy(_ sender: UIButton) {
        print("##AcceptNeedy start")
        needyOrder = NeedyOrders()
        let text : Int = Int((sender ).tag)
        needyOrder = needyList[text]
        print("##AcceptNeedy Button :\(needyOrder.id)")
        UpdateUserStatus()
    }
    
    func UpdateUserStatus () {
        print("##getJsonFromUrl open UpdateUserStatus")
        print("##performPostRequest open UpdateUserStatus")

        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/updateWhenAccepteOne?User_Id=" + needyOrder.id.description + "&Donation_id=" + donationId.description)! // Enter URL Here
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open UpdateUserStatus")
        do {
//            let data = data
//            let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
//            let blogs = json!["result"] as? Bool
 
            if let data = data,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let blogs = json["result"] as? Bool {
                 var check = blogs ;

                print("##UpdateUserStatus check JSON: \(check)")

            }
        } catch {
            print("##Error deserializing JSON: \(error)")
        }
//        self.showNames()
        
    }
    task.resume()
}

    
    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")
        
        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/getNeedyNames?Donation_id=" + donation.DonationId.description)! // Enter URL Here
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open")
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["result"] as? [[String: Any]] {
                    //                    print("##URLSession blogs ")
                    self.needyList.removeAll()
                    self.UserList.removeAll()
                    
                    for blog in blogs {
                        self.donation=Donations()
                        self.donation = self.donation.getDonationsData(dataJson: blog)
                        
                        if let userList = blog["user"] as? [String: Any] {
                            self.user = Users()
                            print("##blogsUser = \(userList)")
                            self.user = self.user.getUsersData(dataJson: userList)
                            self.UserList.append(self.user)
                        }
                            
                            
                            if let needyList = blog["needy"] as? [String: Any] {
                                self.needyOrder = NeedyOrders()
                                print("##blogsUser = \(needyList)")
                                self.needyOrder = self.needyOrder.getOrdersData(dataJson: needyList)
                            
                                self.needyList.append(self.needyOrder)
                        }
                            
                        print("##donationId = \(self.donation.DonationId)")
                        print("##name = \(self.donation.name)")
                        print("##OrderStatus = \(self.donation.OrderStatus)")
                        print("##description = \(self.donation.description)")
                            print("##OrderUser_status = \(self.needyOrder.OrderUser_status)")

                        print("##OrderUser_userId = \(self.needyOrder.User_id)")

                        
                    }
                    
                }
            } catch {
                print("##Error deserializing JSON: \(error)")
            }
            //            print("##names: \(self.names)")
            
            //            print(self.names)
            self.showNames()
            
        }
        task.resume()
        
        
    }
    
    func showNames(){
        //looing through all the elements of the array
        DispatchQueue.main.async {
            self.stopLoding()
            self.TableViewNeedyOrder.dataSource=self
            self.TableViewNeedyOrder.reloadData()
            
            
 
            
        }
    }
    
    
    
    
    func startLoding(){
        self.view.addSubview(view1)
    }
    
    func stopLoding(){
        let subViews = self.view.subviews
        for subview in subViews{
            if subview.tag == 1000{
                subview.removeFromSuperview()
            }
        }
    }
    
    func InitializeSpinner(){
        
        view1 = UIView(frame: CGRect(x: 0 , y: 0 , width: 250 , height: 50))
        
        view1.backgroundColor = UIColor.lightGray
        view1.layer.cornerRadius = 10
        let wait = UIActivityIndicatorView(frame: CGRect(x: 10, y: 0, width: 50, height: 50))
        wait.color = UIColor.black
        wait.hidesWhenStopped = false
        wait.startAnimating()
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        text.text = "يرجى الإنتظار ... "
        view1.addSubview(wait)
        view1.addSubview(text)
        view1.center = self.view.center
        view1.tag = 1000
    }
    
    
    func base64Convert(base64String: String?) -> UIImage{
        //        print("base64String : \(base64String)")
        if (base64String?.isEmpty)! {
            return UIImage(named: "brwsar_iconin.png")!
        }else {
            // !!! Separation part is optional, depends on your Base64String !!!
            let temp = base64String?.components(separatedBy: ",")
            let dataDecoded : Data = Data(base64Encoded: temp![0], options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            return decodedimage!
        }
    }
    
    
}

