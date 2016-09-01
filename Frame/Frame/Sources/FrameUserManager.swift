//
//  FrameUserManager.swift
//  Frame
//
//  Created by Jinhong Kim on 7/15/16.
//  Copyright © 2016 Frame. All rights reserved.
//

import Foundation


class FrameUserManager {
    var storage: FrameUserStorage
    var user: FrameUser?

    
    init(storage: FrameUserStorage) {
        self.storage = storage        
    }
    
    
    func addUser(user: FrameUser) {
        self.storage.addUser(user)
    }
    
    
    func signIn() {
        self.storage.loadUserID { (userID: String?) in
            if let _ = userID {
                self.storage.loadUser(userID!) { (user: FrameUser?) in
                    let event: FrameEvent
                    
                    if let _ = user {
                        self.user = user!
                        event = .SignIn
                    } else {
                        event = .SignOut
                    }
                    
                    frameEventCenter.postEvent(event, data: nil)
                }
            } else {
                frameEventCenter.postEvent(.SignOut, data: nil)
            }
        }
    }
    
    
    func signIn(email: String, password: String) {
        if email.isEmpty && password.isEmpty {
            return
        }
    }
    
    
    func signOut() {
        
    }
    
    
    func signUp(email: String, password: String) {
        
    }
}