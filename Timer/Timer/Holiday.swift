//
//  Holiday.swift
//  Timer
//
//  Created by Bernhard Waidacher on 09.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Foundation
import SwifterSwift

struct Holiday {
    var day:Int
    var month:Int
    var year:Int
    var name:String
    
    var date:Date{
        get{
            return Date(year: year, month: month, day:day)!
        }
        set(val){
            day = val.day
            month = val.month
            year = val.year
        }
    }
}
