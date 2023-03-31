//
//  BaseView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 30.03.2023.
//

import UIKit
import SwiftAlertView

class BaseView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        SwiftAlertView.show(title: title, message: message, buttonTitles: ["ok"]).onButtonClicked {
            _, _ in
            completion?()
        }
    }
    
    func showAlertWithCancel(title: String, message: String, completion: @escaping ( _ buttonIndex: Int) -> Void) {
        SwiftAlertView.show(title: title, message: message, buttonTitles: ["ok", "cancel"]).onButtonClicked {
            _, buttonIndex in
            completion(buttonIndex)
        }
    }
}

/**
 showAlertWithCancel(title: "Success", message: "Successfully created record. You can login.") { buttonIndex in
     switch buttonIndex {
     case 0:
         print("Tamam'a tıklandı")
     case 1:
         self.dismiss(animated: true)
     default:
         print("Bilinmeyen buton")
     }
 }
 
 **/
