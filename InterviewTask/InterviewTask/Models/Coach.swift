//
//  Coach.swift
//  InterviewTask
//
//  Created by Manish Mahajan  on 11/06/20.
//  Copyright © 2020 Manish Mahajan. All rights reserved.
//

import Foundation

class Coach {
    
    let name: String
    let creationDate = Date()
    var completed = false
    var timetaken : String = ""
    var timeInterval = TimeInterval()
    var rank : Int = 1
    var id : UUID
    
    init(name: String , id : UUID) {
        self.name = name
        self.id = id 
    }
}
