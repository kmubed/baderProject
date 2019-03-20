//
//  SlideInTableViewController.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Pooya on 2018-06-19.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit

class SlideInTableViewController: UITableViewController {
    
    var user = Users()
    var view1 = UIView()
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
getJsonFromUrl()
   
    }
    
    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")
        
        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/getUserById?id="+UserInfo.userId.description)! // Enter URL Here
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open")
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["result"] as? [[String: Any]] {
                    //                    print("##URLSession blogs ")
                    
                    for blog in blogs {
                        self.user=Users()
                        self.user = self.user.getUsersData(dataJson: blog)
                        
                        
                        print("##Name = \(self.user.Fname)")
                        print("##email = \(self.user.email)")
                      
                        
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
            
            self.name.text = self.user.Fname + " " + self.user.Lname
            self.email.text = self.user.email
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
        
    }

}
