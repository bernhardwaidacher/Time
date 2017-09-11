//
//  TimerHelper.swift
//  Timer
//
//  Created by Bernhard Waidacher on 09.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire
import AlamofireObjectMapper
import Timberjack


class TimerHelper{
    static let sharedInstance:TimerHelper = TimerHelper()
    private let keychain = KeychainSwift()
    private static let BASE_URL = "https://www.toggl.com/api/v8"
    private static let TIME_ENTRIES = BASE_URL + "/time_entries"
    private static let PASSWORD = "api_token"
    private let holidays:[Holiday] = [
        Holiday(day: 15, month: 8, year: 2017, name: "Maria Himmelfahrt"),
        Holiday(day: 26, month: 10, year: 2017, name: "Nationalfeiertag")
    ]
    private let workingHoursPerDay:Int = 4
    
    private init(){

    }
    
    var apiKey:String? {
        get{
           return keychain.get("api_key")
        }
        set(val){
            if let val = val{
                keychain.set(val, forKey: "api_key")
            }
        }
    }
    
    
    var headers:[String:String]{
        get{
            let credentialData = "\(apiKey!):\(TimerHelper.PASSWORD)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            return ["Authorization": "Basic \(base64Credentials)"]
        }
    }
    func allEntries(completion:@escaping (_ entries:[TimeEntry]?) -> Void) {

        let parameters: Parameters = ["start_date": "2000-09-01T15:42:46+02:00", "end_date": "2100-09-08T15:42:46+02:00"]
        HTTPManager.shared.request(TimerHelper.TIME_ENTRIES,method:.get, parameters: parameters, headers: headers)
            .responseArray{ (response:DataResponse<[TimeEntry]>) in
            
            completion(response.result.value)
        }

    }
    
    func workingHours(for month:Int, year: Int) -> Int{
        //check if holiday time is in toggle??
        let holidays = self.holidays.filter{$0.month == month && $0.year == year}
        let holidayHours = holidays.map{$0.date.isInWeekday}.filter{$0}.count * workingHoursPerDay
        var workingHours = 0
        
        var date = Date(year:year, month: month, day: 1)!
        while date.month == month{
            if date.isInWeekday {
                workingHours += workingHoursPerDay
            }
            
            date = date.adding(.day, value: 1)
        }
        
        return (workingHours - holidayHours) * 3600
    }
    
    func monthView(for month:Int, year:Int, completion:@escaping (_ monthView: MonthView) -> Void){
        let monthView = MonthView(start: Date(year: year, month: month, day:1)!, end: Date(year: year, month: month, day:1)!.end(of: .month)!)
        monthView.timeToWork = workingHours(for: month, year: year)
        
        monthView.dayViews = Array(1...monthView.end.day).map{ day -> (Int, DayView) in
            let date = Date(year: year, month: month, day: day)!
            let dayView = DayView(date: date)
            dayView.holiday = holidays.filter{$0.day == day && $0.month == month && $0.year == year}.first
            monthView.dayViews[day] = dayView
            return (day, dayView)
            }.reduce([Int:DayView](), {a, b in
                var ret = a
                ret[b.0] = b.1
                return ret
            })

        allEntries(completion: { entries in
            guard let entries = entries else {return}
            let monthEntries = entries.filter{$0.start?.month ?? 0 == month && $0.start?.year ?? 0 == year}
            var secondsWorked:Int = 0
            monthEntries.forEach{ entry in
                let dayView = monthView.dayViews[entry.start!.day]
                dayView?.timeEntries.append(entry)
                secondsWorked += entry.duration
            }
            monthView.timeWorked = secondsWorked
            completion(monthView)
        })
        
        
    }
    
    class HTTPManager: Alamofire.SessionManager {
        static let shared: HTTPManager = {
            let configuration = Timberjack.defaultSessionConfiguration()
            let manager = HTTPManager(configuration: configuration)
            return manager
        }()
    }
    
}


