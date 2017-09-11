//
//  TimeEntry.swift
//  Timer
//
//  Created by Bernhard Waidacher on 09.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Foundation
import ObjectMapper

class TimeEntry:Mappable{
    
    var duration:Int = 0
    var start:Date?
    var end:Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        duration <- map["duration"]
        var start:String = ""
        var end:String = ""
        start <- map["start"]
        end <- map["stop"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = Locale(identifier: "de")
        
        self.start = formatter.date(from: start)
        self.end = formatter.date(from: end)
    }
}
