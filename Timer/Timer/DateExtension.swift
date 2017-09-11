//
//  DateExtension.swift
//  Timer
//
//  Created by Bernhard Waidacher on 10.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Foundation


extension Date{
    var weekdayLocale:Int{
        get{
            let calendar = Calendar.current
            var dayOfWeek = calendar.component(.weekday, from: self) + 1 - calendar.firstWeekday
            if dayOfWeek <= 0 {
                dayOfWeek += 7
            }
            
            return dayOfWeek
        }
    }
}
