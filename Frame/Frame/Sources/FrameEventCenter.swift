//
//  FrameEventCenter.swift
//  Frame
//
//  Created by Jinhong Kim on 7/15/16.
//  Copyright © 2016 Frame. All rights reserved.
//

import Foundation

enum FrameEvent: String {
    case SignIn, SignOut, SignUp
}


protocol FrameEventHandler: class {
    func handleFrameEvent(event: FrameEvent, data: Any?)
}


let frameEventCenter = FrameEventCenter()

class FrameEventCenter {
    let eventQueue    = dispatch_queue_create("com.frame.frameeventqueue", DISPATCH_QUEUE_SERIAL)
    var eventHandlers = Dictionary<FrameEvent, [FrameEventHandler]>()
    
    
    func addEventHandler(handler: FrameEventHandler, event: FrameEvent) {
        dispatch_sync(eventQueue) {
            var handlers = self.eventHandlers[event] ?? [FrameEventHandler]()
            handlers.append(handler)
            
            self.eventHandlers[event] = handlers
        }
    }
    
    
    func removeEventHandler(handler: FrameEventHandler, event: FrameEvent) {
        dispatch_sync(eventQueue) {
            if var handlers = self.eventHandlers[event] {
                for (idx, h) in handlers.enumerate() {
                    if h === handler {
                        handlers.removeAtIndex(idx)
                        break
                    }
                }
                
                self.eventHandlers[event] = handlers
            }
        }
    }
    
    
    func removeEventHandler(handler: FrameEventHandler) {
        dispatch_sync(eventQueue) {
            for (key, value) in self.eventHandlers {
                var handlers = value
                
                for (idx, h) in handlers.enumerate() {
                    if h === handler {
                        handlers.removeAtIndex(idx)
                    }
                }
                
                self.eventHandlers[key] = handlers
            }
        }
    }
    
    
    func postEvent(event: FrameEvent, data: Any?) {
        dispatch_async(eventQueue) {
            if let handlers = self.eventHandlers[event] {
                for handler in handlers {
                    handler.handleFrameEvent(event, data: data)
                }
            }
        }
    }
}