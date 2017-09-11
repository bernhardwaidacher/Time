//
//  CalendarViewItem.swift
//  Timer
//
//  Created by Bernhard Waidacher on 10.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Cocoa
import SwifterSwift

class CalendarViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var day: NSTextField!
    @IBOutlet weak var subtitle: NSTextField!
    
    var dayView:DayView?{
        didSet{
            guard let val = dayView else{return}
            day.stringValue = "\(val.date.day)"
            if let holiday = val.holiday{
                self.view.layer?.backgroundColor = NSColor.yellow.cgColor
                subtitle.stringValue = holiday.name
            }else{
                if(val.totalWorkTime > 0){
                    subtitle.stringValue = val.totalWorkTime.hourString
                }
                
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reset()
    }
    
    func reset(){
        day.stringValue = ""
        subtitle.stringValue = ""
    }
    
    
}
