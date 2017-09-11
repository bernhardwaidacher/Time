//
//  EventMonitor.swift
//  Timer
//
//  Created by Bernhard Waidacher on 09.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Cocoa

public class EventMonitor {
    private var monitor: Any?
    private let mask: NSEventMask
    private let handler: (NSEvent?) -> Void
    
    public init(mask: NSEventMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
