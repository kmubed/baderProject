//
//  AddDonationVC.swift
//  Bader
//
//  Created by Itc on 05/02/2019.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

class AddDonationVC: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    @IBOutlet weak var donationName: UITextField!
    @IBOutlet weak var donationDescription: UITextField!
    @IBOutlet weak var donationType: UIButton!
    
    let typeList = ["نوع١", "نوع٢", "نوع٣", "نوع٤"]

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
        getJsonFromUrl()
    }
    

    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")

        let donationNameStr = (donationName.text)! as String
        let donationTypeStr = ((donationType.tag + 1).description) as String
        let donationDescriptionStr = (donationDescription.text)! as String
        let imageBase64Str = convertImageToBase64(image: myImageView.image!)
        let fullBase64String = "data:image/png;base64,\(imageBase64Str))"

//        print("##imageBase64Str \(imageBase64Str)")

        let linkString = "http://amjadsufyani-001-site1.itempurl.com/api/values/AddDonations?"
        let linkParameter = "Name=\(donationNameStr)&Description=\(donationDescriptionStr)&Type=\(donationTypeStr)&Id_of_Donor=0&imageBase=\(fullBase64String)".addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
        let url = URL(string: (linkString) )! // Enter URL Here


        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession \(url.description)")
            do {

                //                if let data = data,
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)as? [String: Any],
                    let blogs = json["result"] as? Int {
                    print("##blog Added donation = \(blogs.description)")
                    
                    //                    for blog in blogs {
                    //                    self.user = self.user.getUsersData(dataJson: blogs)
                    //
                    //                    print("##UserId = \(self.user.UserId)")
                    //                    print("##Fname = \(self.user.Fname)")
                    //
                    //                }
                }
            } catch {
                print("##Error deserializing JSON: \(error)")
            }

            //            print(self.names)
            self.showNames()

        }
        task.resume()


    }
    
    func showNames(){
        //looing through all the elements of the array
        DispatchQueue.main.async {
            
            //            self.donationName.text = self.donation.name
            //            self.donationUserName.text = self.user.Fname + self.user.Lname
            //            self.donationUserEmail.text = self.user.email
            //            self.donationImage.image = self.base64Convert(base64String: self.donation.image)
            //            self.donationDesc.text = self.donation.description
            
        }
    }
}
