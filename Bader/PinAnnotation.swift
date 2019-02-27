//
//  PinAnnotation.swift
//  Bader
//
//  Created by Itc on 25/02/2019.
//  Copyright © 2019 aa. All rights reserved.
//

import MapKit
import Foundation
import UIKit

class PinAnnotation : NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var title: String?
    
    var subtitle: String?
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    

    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}
