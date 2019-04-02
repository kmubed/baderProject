//
//  DashboardViewController.swift
//  Bader
//
//  Created by AMJAD - on 28 جما٢، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//

import UIKit

class DashboardViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       getJsonFromUrl()
    }
  

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 12
    }

    
    
    @IBOutlet weak var donations: UILabel!
    @IBOutlet weak var clothes: UILabel!
    @IBOutlet weak var Furniture: UILabel!
    @IBOutlet weak var paper: UILabel!
    @IBOutlet weak var ElectricMachines: UILabel!
    @IBOutlet weak var NumUsers: UILabel!
    @IBOutlet weak var ActiveUsers: UILabel!
    @IBOutlet weak var UnActiveUsers: UILabel!
    @IBOutlet weak var charities: UILabel!
    @IBOutlet weak var orders: UILabel!
    @IBOutlet weak var finished: UILabel!
    @IBOutlet weak var availabe: UILabel!
    
    
    
    var dashboard = Dashboard()
    var view1 = UIView()
    
    
    
    
    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")
        
        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/Admin")! // Enter URL Here
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open")
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["result"] as? [[String: Any]] {
                    //                    print("##URLSession blogs ")
                    
                    for blog in blogs {
                        self.dashboard=Dashboard()
                        self.dashboard = self.dashboard.getData(dataJson: blog)
                        
                        
                        print("##Num_Donations = \(self.dashboard.Num_of_Donations)")
                        print("##Num_Clothes = \(self.dashboard.Num_of_Clothes)")
                        print("##Num_ElectricMachines = \(self.dashboard.Num_of_ElectricMachines)")
                        print("##Num_Furniture = \(self.dashboard.Num_of_Furniture)")
                        print("##Num_Paper = \(self.dashboard.Num_of_Paper)")
                        
                        
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
            
            self.donations.text = self.dashboard.Num_of_Donations.description
            self.clothes.text = self.dashboard.Num_of_Clothes.description
            self.Furniture.text = self.dashboard.Num_of_Furniture.description
            self.ElectricMachines.text = self.dashboard.Num_of_ElectricMachines.description
            self.paper.text = self.dashboard.Num_of_Paper.description
            self.NumUsers.text = self.dashboard.Number_of_Users.description
            self.UnActiveUsers.text = self.dashboard.Num_of_UnActive_Users.description
            self.ActiveUsers.text = self.dashboard.Num_of_Active_Users.description
            self.charities.text = self.dashboard.Num_of_Charities.description
            self.orders.text = self.dashboard.Num_of_Order.description
            self.finished.text = self.dashboard.expiry_Percent.description
            self.availabe.text = self.dashboard.Available_Percent.description
            
            
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


    

