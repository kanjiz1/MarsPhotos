//
//  AppDelegate.swift
//  MarsPhotos
//
//  Created by Oforkanji Odekpe on 6/25/20.
//  Copyright © 2020 Oforkanji Odekpe. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mainViewController: MainViewController!
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Photo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
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

