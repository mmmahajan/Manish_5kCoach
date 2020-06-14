//
//  Date++.swift
//  InterviewTask
//
//  Created by Manish Mahajan  on 14/06/20.
//  Copyright © 2020 Manish Mahajan. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
