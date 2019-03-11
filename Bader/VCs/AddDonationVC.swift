//
//  AddDonationVC.swift
//  Bader
//
//  Created by Itc on 05/02/2019.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

class AddDonationVC: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate{

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    @IBOutlet weak var donationName: UITextField!
    @IBOutlet weak var donationDescription: UITextField!
    @IBOutlet weak var donationType: UIButton!
    
   let typeList = ["ملابس", "أجهزة كهربائية", "أثاث", "أوراق"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if revealViewController() != nil {
            print("revealViewController not null ")
            
            menuBarItem.target = self.revealViewController()
            menuBarItem.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
//        self.donationType.setTitle(typeList[0], for: .normal)

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    @IBAction func changeType(_ sender: Any) {
        
        RPicker.selectOption(dataArray: typeList) { (selctedText, atIndex) in
            // TODO: Your implementation for selection
            self.donationType.setTitle(selctedText, for: .normal)
            self.donationType.tag = atIndex
        }
    }
 
    @IBAction func importImage(_ sender: AnyObject)
    {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After it is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[.originalImage] as? UIImage
        {
            myImageView.isHidden = false
            myImageView.image = image
        }
        else
        {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        
//        let imageData = image.jpegData(compressionQuality: 0.75)
//        return imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        let imageData: Data? = image.jpegData(compressionQuality: 0.4)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        return imageStr
    }
    
    @IBAction func addDonation(_ sender: Any) {
        postRequest()

    }
    

    func postRequest() {
        
        let donationNameStr = (donationName.text)! as String
        let donationTypeStr = ((donationType.tag + 1).description) as String
        let donationDescriptionStr = (donationDescription.text)! as String
        let imageBase64Str = convertImageToBase64(image: myImageView.image!)
        let fullBase64String = "data:image/png;base64,\(imageBase64Str))"
        
        print("##imageBase64Str \(imageBase64Str)")
        
        let linkString = "http://amjadsufyani-001-site1.itempurl.com/api/values/AddDonations"
        let linkParameter = "Name=\(donationNameStr)&Description=\(donationDescriptionStr)&Type=\(donationTypeStr)&Id_of_Donor=0".addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
        let url = URL(string: (linkString) )! // Enter URL Here
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let jsondata = ["Name":donationNameStr,"Description":donationDescriptionStr,"Type":donationTypeStr,"Id_of_Donor":"0","Image":imageBase64Str]
        
        
        //        PlaygroundPage.current.needsIndefiniteExecution = true
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsondata, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }
            
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
                let blogs = json["result"] as? Int
                print("blogs:", blogs)
                
                if(blogs ?? 0 > 0){
                    let alert = UIAlertController(title: "تم إضافة تبرعك إلى صفحة التبرعات", message: "", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }

            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }
    
    func showNames(){
        //looing through all the elements of the array
        DispatchQueue.main.async {

            
            
        }
    }
}
