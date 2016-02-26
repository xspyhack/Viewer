//
//  AppearenceManager.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/24/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation
import UIKit

struct AppearanceManager {
    
    private static let tintColor = UIColor(red: 23 / 255.0, green: 87 / 255.0, blue: 134 / 255.0, alpha: 1.0)
    
    static func configure() {
        // NavigationBar Item Style
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: tintColor], forState: .Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState: .Disabled)

        // NavigationBar Title Style
        let shadow: NSShadow = {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.lightGrayColor()
            shadow.shadowOffset = CGSizeMake(0, 0)
            return shadow
        }()
        
        let textAttributes = [
            NSForegroundColorAttributeName: tintColor,
            NSShadowAttributeName: shadow,
        ]
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = tintColor
    }
}