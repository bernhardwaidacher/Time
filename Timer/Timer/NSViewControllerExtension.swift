//
//  NSViewControllerExtension.swift
//  Timer
//
//  Created by Bernhard Waidacher on 09.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Foundation
import Cocoa
import SwifterSwift

extension NSViewController{
    
    
    static func freshController(of className:String) -> NSViewController{
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateController(withIdentifier: className) as? NSViewController else {fatalError("cant init \(className)")}
        
        return vc
    }
    
    
}
