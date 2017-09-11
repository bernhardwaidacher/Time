//
//  ApiKeyViewController.swift
//  Timer
//
//  Created by Bernhard Waidacher on 09.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Foundation
import Cocoa
import SwifterSwift

class ApiKeyViewController:NSViewController{
    
    
    @IBOutlet weak var apiKey: NSTextField!
    
    @IBAction func saveApiKey(_ sender: Any) {
        
        if apiKey.stringValue.length > 0{
            TimerHelper.sharedInstance.apiKey = apiKey.stringValue
            let delegate = NSApplication.shared().delegate as! AppDelegate
            delegate.changePopoverVC(to: NSViewController.freshController(of: "TimerViewController"))
        }
    }
}
