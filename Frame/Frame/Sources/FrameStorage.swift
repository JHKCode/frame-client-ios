//
//  FrameStorage.swift
//  Frame
//
//  Created by Jinhong Kim on 7/20/16.
//  Copyright © 2016 Frame. All rights reserved.
//

import Foundation


protocol FrameUserStorage {
    func loadUserID(handler: String? -> Void)
    func loadUser(ID: String, handler: FrameUser? -> Void)
    func addUser(user: FrameUser) -> Void
    func removeUser(ID: String) -> Void
}


struct FrameUserDefaults: FrameUserStorage {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    func loadUserID(handler: String? -> Void) {
        let userID = userDefaults.objectForKey("userID") as? String
        
        handler(userID)
    }
    
    
    func loadUser(ID: String, handler: FrameUser? -> Void) {
    }
    
    
    func addUser(user: FrameUser) {
        
    }
    
    
    func removeUser(ID: String) {
        
    }
}