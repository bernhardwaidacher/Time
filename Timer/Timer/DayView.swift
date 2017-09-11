//
//  DayView.swift
//  Timer
//
//  Created by Bernhard Waidacher on 10.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Foundation
import SwifterSwift

class DayView{
    var date:Date
    var holiday:Holiday?
    var timeEntries:[TimeEntry] = []
    
    init(date:Date) {
        self.date = date
    }
    
    var totalWorkTime:Int{
        get{
            return timeEntries.map{$0.duration}.sum()
        }
    }
}
