//
//  MonthView.swift
//  Timer
//
//  Created by Bernhard Waidacher on 10.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Foundation


class MonthView{
    var start:Date
    var end:Date
    var dayViews:[Int:DayView]
    var timeToWork:Int = 0
    var timeWorked:Int = 0
    var hoursPerDay = 4
    
    var gapStart:Int{
        get{
            return (start.weekdayLocale - 1)
        }
    }
    
    var gapEnd:Int{
        get{
            return (7 - end.weekdayLocale)
        }
    }
    
    var days:Int{
        get{
          return end.day + gapStart + gapEnd
        }
    }
    
    init(start: Date, end: Date){
        self.start = start
        self.end = end
        dayViews = [:]
    }
}


extension Int{
    var hourString:String{
        get{
            return String(format: "%02d:%02d", self/3600, (self % 3600) / 60)
        }
    }
}
