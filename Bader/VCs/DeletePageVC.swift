//
//  DeletePageVC.swift
//  Bader
//
//  Created by AMJAD - on 27 جما٢، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//

import Foundation

import UIKit

class DeletePageVC : UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var DeleteTableview: UITableView!
    

  
    
  
    var donation = Donations()
    var user = Users()
    var view1 = UIView()
    //var needyList = [NeedyOrders()]
    var UserList = [Users()]
    var donationList = [Donations()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
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
        let cell = self.DeleteTableview.dequeueReusableCell(withIdentifier: "DeleteCell", for: indexPath) as! DeleteItemCell
        
        var donationCell : Donations = Donations()
        donationCell  = self.donationList[indexPath.row]
        var userCell : Users = Users()
        userCell  = self.UserList[indexPath.row]
        
        
        print("donation.name : \(donation.name)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'/'HH':'mm"
        
        //        cell.UploadDate.text = (dateFormatter.date(from: "donation.DateOfUpload" ))?.description
        
        if(donationCell.DonationId == 0){
            cell.DeleteButton.isHidden = true
        }else{
            cell.DeleteButton.isHidden = false
            
        }
        
        cell.Donation.text = donationCell.name
        cell.PersonName.text = userCell.Fname + " " + userCell.Lname
        //cell.ImageItem.image = base64Convert(base64String: donationCell.image)
        
        
        
        cell.DeleteButton.tag = indexPath.row
        cell.DeleteButton.addTarget(self, action: #selector(AcceptDelete) , for: .touchUpInside)
        
        let separatorLine = UIImageView.init(frame: CGRect(x: 4, y: 0, width: cell.frame.width - 8, height: 2))
        separatorLine.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 250/255, alpha: 100)
        cell.addSubview(separatorLine)
        
        return cell
        
    }
    
    
    @IBAction func AcceptDelete(_ sender: UIButton) {
        print("##AcceptNeedy start")
      
        let alert = UIAlertController(title: "هل تريد حذف هذا التبرع؟", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { action in
            self.donation = Donations()
            let text : Int = Int((sender ).tag)
            self.donation = self.donationList[text]
            print("##AcceptNeedy Button :\(self.donation.DonationId)")
            self.UpdateUserStatus(id: self.donation.DonationId)
        }))
        alert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
//        donation = Donations()
//        let text : Int = Int((sender ).tag)
//        donation = donationList[text]
//        print("##AcceptNeedy Button :\(donation.DonationId)")
//        UpdateUserStatus(id: donation.DonationId)
        
        
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
        
        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/getAllDonations?type=0&status=2" )!
        
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
                            self.user=Users()
                            self.user = self.user.getUsersData(dataJson: userList)
                            
                        }
                        print("##donationId = \(self.donation.DonationId)")
                        print("##name = \(self.donation.name)")
                        print("##OrderStatus = \(self.donation.OrderStatus)")
                        print("##user Fname = \(self.user.Fname)")
                      
                        
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
            
            self.DeleteTableview.dataSource=self
            self.DeleteTableview.reloadData()
            
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
        
        view1.backgroundColor = UIColor.init(red: 119/255, green: 154/255, blue: 218/255, alpha: 1)
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
