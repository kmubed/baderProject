//
//  MapVC.swift
//  Bader
//
//  Created by Itc on 24/02/2019.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
import MapKit
class MapVC: UIViewController , MKMapViewDelegate{

    @IBOutlet weak var menuBarItem: UIBarButtonItem!

    @IBOutlet weak var mapView: MKMapView!
    var view1 = UIView()
    var coords = [Charities()];
    let regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()

        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 8,longitudeDelta: 8)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(21.266638, 40.416055)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location , span: span)
        mapView.setRegion(region, animated: true)
 
        if revealViewController() != nil {
            print("revealViewController not null ")
            
            menuBarItem.target = self.revealViewController()
            menuBarItem.action = #selector(SWRevealViewController().revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        InitializeSpinner()
        startLoding()
        getJsonFromUrl()
        
  

//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "title"
//        annotation.subtitle = "subTitle"
//        map.addAnnotation(annotation)
        
        // Do any additional setup after loading the view.
    }
    


    func addAnnotations(coords: [Charities]){

        for coord in coords{
            print("anno for loop\(coord.CharityId) ")
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.Coordinate_X,longitude: coord.Coordinate_Y);
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType
                    anno.title = coord.Name
                    anno.subtitle = coord.Phone
                    mapView.addAnnotation(anno)
        }
        
    }

    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")
        
        let url = URL(string: "http://amjadsufyani-001-site1.itempurl.com/api/values/getAllCharities")!
        
        //+UserInfo.userId.description)! // Enter URL Here
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open")
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["result"] as? [[String: Any]] {
                    //                    print("##URLSession blogs ")
                    self.coords.removeAll()
                    for blog in blogs {
                        var charit=Charities()
                        charit = charit.getCharitiesData(dataJson: blog)
                        //                        if let name = blog["Name"] as? String {print("##Name : \(name)")}
                        
                        print("##CharityId = \(charit.CharityId)")
                        print("##name = \(charit.Name)")
                        print("##Phone = \(charit.Phone)")
                        print("##Coordinate_X = \(charit.Coordinate_X)")
                        print("##Coordinate_Y= \(charit.Coordinate_Y)")
                        
                        
                        self.coords.append(charit)
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
            self.addAnnotations(coords: self.coords)

            self.mapView.delegate = self

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
 
}
