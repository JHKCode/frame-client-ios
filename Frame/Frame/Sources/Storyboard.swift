//
//  Storyboard.swift
//  Frame
//
//  Created by Jinhong Kim on 7/14/16.
//  Copyright © 2016 Frame. All rights reserved.
//

import UIKit


enum StoryboardSceneID: String {
    case SignIn
    case Frames
}


enum StoryboardSegueID: String {
    case SignIn
}


func viewControllerFromStoryboard(sceneID: StoryboardSceneID) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    return storyboard.instantiateViewControllerWithIdentifier(sceneID.rawValue)
}


extension UIViewController {
    func presentViewController(segueID: StoryboardSegueID) {
        self.performSegueWithIdentifier(segueID.rawValue, sender: self)
    }
}