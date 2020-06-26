//
//  AppDelegate.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/25/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mainViewController: MainViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
        let win = UIWindow(frame: UIScreen.main.bounds)
               win.overrideUserInterfaceStyle = .unspecified
               mainViewController = MainViewController()
               win.rootViewController = mainViewController
               win.makeKeyAndVisible()
               
               window = win
        
        return true
    }


}

