//
//  UIViewController++.swift
//  InterviewTask
//
//  Created by Manish Mahajan on 14/06/20.
//  Copyright © 2020 Manish Mahajan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title : String , message : String) {
        let alertController =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
