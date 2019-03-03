//
//  LoginVC.swift
//  Bader
//
//  Created by AMJAD - on 18 جما١، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//

import UIKit
import Foundation

class LoginVC : UIViewController
{
    @IBOutlet weak var email: XTextField!
    @IBOutlet weak var password: XTextField!
    
    var user:Users = Users()
    @IBAction func Login(_ sender: Any) {
        getJsonFromUrl()
//        let goToHomePage = self.storyboard?.instantiateViewController(withIdentifier: "AfterLogin") as! TabBarController
//        self.present(goToHomePage, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBOutlet weak var ButtonLayout: NSLayoutConstraint!
    override func viewDidLoad() {
        SettingUpKeyboardNotification()
        UserInfo.userId=4
        
        
    }
    
} 

extension LoginVC {
    
    func SettingUpKeyboardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardDidHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    @objc func KeyboardDidShow (notification : NSNotification) {
        // ارتفاع الكيبورد، نجلب الحجم للحصول ع الارتفاع
        if let KeyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.ButtonLayout.constant = KeyboardSize.height + 30
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func KeyboardDidHide(notification : NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.ButtonLayout.constant = 210
            self.view.layoutIfNeeded() //يعني قم باعادة عملية ال لاي اوت في داخل الفيو
        }
    
}
    
    
    
    
    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")
        let useremail = (email.text)! as String
        let userPassword = (password.text)! as String
        
        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/getLogin?email=\(useremail)&password=\(userPassword)")! // Enter URL Here
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open")
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["result"] as? [String: Any] {
                    print("##blog = \(blogs.count)")
//                    for blog in blogs {
                        self.user = self.user.getUsersData(dataJson: blogs)
                        
                        print("##UserId = \(self.user.UserId)")
                        print("##Fname = \(self.user.Fname)")
                       print("##type = \(self.user.type)")
                    
                        
                                            }
//                }
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
 
            if(self.user.UserId != 0)
            {
                
           //     UserInfo.userId = 4
                UserInfo.userId=self.user.UserId
                if (self.user.type == 2)
                {
                let goToHomePage = self.storyboard?.instantiateViewController(withIdentifier: "AfterLogin1") as! TabBarController
                self.present(goToHomePage, animated: true, completion: nil)
                } else {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "AfterLogin2")
//                self.present(controller, animated: true, completion: nil)
                    
                    let goToHomePage = self.storyboard?.instantiateViewController(withIdentifier: "AfterLogin2") as! SWRevealViewController
                    self.present(goToHomePage, animated: true, completion: nil)
                }
                
                
                
//                if let window = self.window{
//                    window.rootViewController = controller
//                }

                
            }
        }
    }
}
