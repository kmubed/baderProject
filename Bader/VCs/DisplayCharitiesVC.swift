//
//  DisplayCharitiesVC.swift
//  Bader
//
//  Created by AMJAD - on 14 رجب، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//


import UIKit

class DisplayCharitiesVC : UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var TableViewData: UITableView!
    
    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    
    var charity=Charities()
    
    var view1 = UIView()
    
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
        
        return self.donationList.count
        //                return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.TableViewData.dequeueReusableCell(withIdentifier: "CellData", for: indexPath) as! MyOrders_DonationsCell
        
        var donation : Donations = self.donationList[indexPath.row]
        
        
        print("donation.name : \(donation.name)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'/'HH':'mm"
        
        cell.name.text = donation.name
        cell.descriptions.text = donation.description
        cell.UploadDate.text = (dateFormatter.date(from: "donation.DateOfUpload" ))?.description
        cell.images.image = base64Convert(base64String: donation.image)
        
        var orderCell : NeedyOrders = NeedyOrders()
        orderCell  = self.OrdersList[indexPath.row]
        
        // let orders = NeedyOrders()
        print("OrderUser_status : \(orderCell.OrderUser_status)")
        if orderCell.OrderUser_status == 1 {
            cell.status.text = "قيد الانتظار"
        }
        else if orderCell.OrderUser_status == 2 {
            cell.status.text = "مقبول"
        }
        else if orderCell.OrderUser_status == 3 {
            cell.status.text = "مرفوض"
        }
        
        let separatorLine = UIImageView.init(frame: CGRect(x: 4, y: 0, width: cell.frame.width - 8, height: 2))
        separatorLine.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 250/255, alpha: 100)
        cell.addSubview(separatorLine)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = donationList[indexPath.row]
        print("##item : \(donationList[indexPath.row])")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "segueMMyOrders") as! MyOrdersDetailsaVC
        vc.donationId = item.DonationId
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")
        
        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/getMyOrder?Id_Needy="+UserInfo.userId.description)!
        
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open")
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["result"] as? [[String: Any]] {
                    //                    print("##URLSession blogs ")
                    self.donationList.removeAll()
                    self.OrdersList.removeAll()
                    for blog in blogs {
                        //var donation=Donations()
                        self.donation = self.donation.getDonationsData(dataJson: blog)
                        //                        if let name = blog["Name"] as? String {print("##Name : \(name)")}
                        
                        print("##donationId = \(self.donation.DonationId)")
                        print("##name = \(self.donation.name)")
                        print("##OrderStatus = \(self.donation.OrderStatus)")
                        print("##description = \(self.donation.description)")
                        
                        if var ordersJson = blog["needy"] as? [String: Any] {
                            // var orders = NeedyOrders()
                            
                            self.order = self.order.getOrdersData(dataJson: ordersJson)
                            print("OrderUser_status json: \(ordersJson)")
                            self.OrdersList.append(self.order)
                        }
                        
                        
                        
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
            
            self.TableViewData.dataSource=self
            self.TableViewData.reloadData()
            
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




