//
//  dashboard.swift
//  Bader
//
//  Created by AMJAD - on 21 جما٢، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//

import Foundation


class Dashboard {
    var Num_of_Donations : Int = 0
    var Num_of_Clothes : Int = 0
    var Num_of_ElectricMachines : Int = 0
    var Num_of_Furniture : Int = 0
    var Num_of_Paper : Int = 0
    var Number_of_Users : Int = 0
    var Num_of_UnActive_Users : Int = 0
    var Num_of_Active_Users : Int = 0
    var Num_of_Charities : Int = 0
    var Num_of_Order : Int = 0
    var Available_Percent : Int = 0
    var expiry_Percent : Int = 0
    

    
    func getData( dataJson:[String: Any] ) -> (Dashboard) {
        var dashboard = Dashboard()
        dashboard.Num_of_Donations = dataJson["Num_of_Donations"] as? Int ?? 0
        dashboard.Num_of_Clothes = dataJson["Num_of_Clothes"] as? Int ?? 0
        dashboard.Num_of_ElectricMachines = dataJson["Num_of_ElectricMachines"] as? Int ?? 0
        dashboard.Num_of_Furniture = dataJson["Num_of_Furniture"] as? Int ?? 0
        dashboard.Num_of_Paper = dataJson["Num_of_Paper"] as? Int ?? 0
        dashboard.Number_of_Users = dataJson["Number_of_Users"] as? Int ?? 0
        dashboard.Num_of_UnActive_Users = dataJson["Num_of_UnActive_Users"] as? Int ?? 0
        dashboard.Num_of_Active_Users = dataJson["Num_of_Active_Users"] as? Int ?? 0
        dashboard.Num_of_Charities = dataJson["Num_of_Charities"] as? Int ?? 0
        dashboard.Num_of_Order = dataJson["Num_of_Order"] as? Int ?? 0
        dashboard.Available_Percent = dataJson["Available_Percent"] as? Int ?? 0
        dashboard.expiry_Percent = dataJson["expiry_Percent"] as? Int ?? 0
        
        
        return dashboard
    }
    
    
}
