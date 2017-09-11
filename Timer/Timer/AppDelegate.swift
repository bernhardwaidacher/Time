//
//  AppDelegate.swift
//  Timer
//
//  Created by Bernhard Waidacher on 09.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Cocoa
import Timberjack

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    private let popover = NSPopover()
    private var eventMonitor:EventMonitor?
    private let helper = TimerHelper.sharedInstance

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        Timberjack.register()
        
        if let button = statusItem.button{
            
            button.image = NSImage(named: "icon")
            button.action = #selector(AppDelegate.appIconClick(_:))
        }
        
        if helper.apiKey == nil{
           popover.contentViewController = ApiKeyViewController.freshController(of: "ApiKeyViewController")
        }else{
            popover.contentViewController = TimerViewController.freshController(of: "TimerViewController")
        }
        
        
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: {event in
            if self.popover.isShown{
                self.closePopover()
            }
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc private func appIconClick(_ sender: Any?){
        
        if popover.isShown{
            //close
            closePopover()
        }else{
            //show
            if let button = statusItem.button{
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
            eventMonitor?.start()
        }
    }
    
    func closePopover(){
        popover.performClose(nil)
        eventMonitor?.stop()
    }
    
    func changePopoverVC(to:NSViewController){
        popover.contentViewController = to
    }


}



