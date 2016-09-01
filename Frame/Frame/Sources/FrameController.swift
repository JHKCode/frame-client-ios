//
//  FrameController.swift
//  Frame
//
//  Created by Jinhong Kim on 7/20/16.
//  Copyright © 2016 Frame. All rights reserved.
//

import Foundation
import UIKit


class FrameController: FrameEventHandler {
    init() {
        frameEventCenter.addEventHandler(self, event: .SignUp)
        frameEventCenter.addEventHandler(self, event: .SignIn)
        frameEventCenter.addEventHandler(self, event: .SignOut)
    }
    
    
    deinit {
        frameEventCenter.removeEventHandler(self)
    }
    
    
    func handleFrameEvent(event: FrameEvent, data: Any?) {
        dispatch_async(dispatch_get_main_queue()) { 
            switch event {
            case .SignUp:
                self.presentFrames()
                
            case .SignIn:
                self.presentFrames()
                
            case .SignOut:
                self.presentSignIn()
            }
        }
    }
    
    
    func presentSignIn() {
        let vc  = viewControllerFromStoryboard(.SignIn)
        let nvc = UINavigationController.init(rootViewController: vc)
        
        AppDelegate.instance().window?.rootViewController = nvc
    }
    
    
    func presentFrames() {
        
    }
}