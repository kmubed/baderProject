//
//  test1.swift
//  Bader
//
//  Created by AMJAD - on 1 رجب، 1440 هـ.
//  Copyright © 1440 هـ aa. All rights reserved.
//

import UIKit

class test1: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var nametextfeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // test
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


