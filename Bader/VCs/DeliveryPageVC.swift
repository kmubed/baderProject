//
//  DeliveryPageVC.swift
//  Bader
//
//  Created by AMJAD - on 4 جما٢، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//

import UIKit

class DeliveryPageVC : UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var DeliveryTableView: UITableView!
    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    
    var donation = Donations()
    var user = Users()
    var view1 = UIView()
    //var needyList = [NeedyOrders()]
    var UserList = [Users()]
    var donationList = [Donations()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            print("revealViewController not null ")
            
            menuBarItem.target = self.revealViewController()
            menuBarItem.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        InitializeSpinner()
        startLoding()
        getJsonFromUrl()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        print("count return : \(donationList.count)")
        stopLoding()
        if(donationList.count == 0){
            donation = Donations()
            donation.name = "لا يوجد طلبات حاليا"
            donation.DonationId = 0
            
            self.donationList.append(donation)
        }
        
        return self.donationList.count
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.DeliveryTableView.dequeueReusableCell(withIdentifier: "DeliveryCell", for: indexPath) as! DeliveryTableViewCell
        
        
        var donation : Donations = self.donationList[indexPath.row]
        var user : Users = self.UserList[indexPath.row]
        
        
        print("donation.name : \(donation.name)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'/'HH':'mm"
        
        //        cell.UploadDate.text = (dateFormatter.date(from: "donation.DateOfUpload" ))?.description
        
        if(self.donation.DonationId == 0){
            cell.deliveryButton.isHidden = true
        }else{
            cell.deliveryButton.isHidden = false
            
        }
        
        cell.DonationName.isHidden = false
        cell.NeedyName.isHidden = false
        cell.Email.isHidden = false
        cell.City.isHidden = false
       
        
        cell.DonationName.text = self.donation.name
        cell.NeedyName.text = self.user.Fname + " " + self.user.Lname
        cell.Email.text = self.user.email
        cell.City.text = self.user.city
        cell.DonationImage.image = base64Convert(base64String: donation.image)
        
        
        
        cell.deliveryButton.tag = indexPath.row
        cell.deliveryButton.addTarget(self, action: #selector(AcceptDelivery) , for: .touchUpInside)
        
        let separatorLine = UIImageView.init(frame: CGRect(x: 4, y: 0, width: cell.frame.width - 8, height: 2))
        separatorLine.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 250/255, alpha: 100)
        cell.addSubview(separatorLine)
        
        return cell
        
    }
    
    
    @IBAction func AcceptDelivery(_ sender: UIButton) {
        print("##AcceptNeedy start")
        let alert = UIAlertController(title: "هل أنت متأكد من قدرتك على توصيل هذا التبرع؟", message: "سيتم إزالة هذا التبرع من قائمة التبرعات عند تأكيد التوصيل", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: " تأكيد", style: .default, handler: { action in
            self.donation = Donations()
            let text : Int = Int((sender ).tag)
            self.donation = self.donationList[text]
            print("##AcceptNeedy Button :\(self.donation.DonationId)")
            self.UpdateUserStatus(id: self.donation.DonationId)
        }))
        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func UpdateUserStatus (id: Int) {
        print("##getJsonFromUrl open UpdateUserStatus")
        print("##performPostRequest open UpdateUserStatus \(id.description)")
        let urlUpdate = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/updateWhenDonerDelivery?Donation_id=\(id.description)" )!
        let task = URLSession.shared.dataTask(with: urlUpdate) { (data, response, error) in
            print("##URLSession open UpdateUserStatus")
            do {
                //            let data = data
                //            let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                //            let blogs = json!["result"] as? Bool
                
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["result"] as? Bool {
                    let check = blogs ;
                    
                    print("##UpdateUserStatus check JSON: \(check)")
                    
                }
            } catch {
                print("##Error deserializing JSON: \(error)")
            }
            //        self.showNames()
            self.InitializeSpinner()
            self.startLoding()
            self.getJsonFromUrl()
            
        }
        task.resume()
    }
    
    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")
        
        self.donationList.removeAll()
        
        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/DeliverPage" )!
        
        //+UserInfo.userId.description)! // Enter URL Here
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open")
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["result"] as? [[String: Any]] {
                    //                    print("##URLSession blogs ")
                    self.donationList.removeAll()
                    for blog in blogs {
                        self.donation=Donations()
                        self.donation = self.donation.getDonationsData(dataJson: blog)
                        
                        if let userList = blog["user"] as? [String: Any] {
                            //                            print("##blogsUser = \(userList)")
                            //                            print("##blogsUser = \(userList)")
                            self.user = self.user.getUsersData(dataJson: userList)
                            
                        }
                        print("##donationId = \(self.donation.DonationId)")
                        print("##name = \(self.donation.name)")
                        print("##OrderStatus = \(self.donation.OrderStatus)")
                        print("##user Fname = \(self.user.Fname)")
                        print("##user mail = \(self.user.email)")
                        print("##user city = \(self.user.city)")
                        
                        self.UserList.append(self.user)
                        self.donationList.append(self.donation)
                        
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
            
            self.DeliveryTableView.dataSource=self
            self.DeliveryTableView.reloadData()
            
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

