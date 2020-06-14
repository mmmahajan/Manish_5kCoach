//
//  Color++.swift
//  InterviewTask
//
//  Created by Manish Mahajan on 14/06/20.
//  Copyright © 2020 Manish Mahajan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}

extension UIColor {
    struct FlatColor {
        static let PrimaryColor = UIColor.init(rgb: 0xff9f00)
        static let LightPrimaryColor = UIColor.init(rgb: 0xffa84d)
        static let SecondaryColor = UIColor.init(rgb: 0x000000)
        static let RedColor = UIColor.init(rgb: 0xe5503e)        
    }
}
