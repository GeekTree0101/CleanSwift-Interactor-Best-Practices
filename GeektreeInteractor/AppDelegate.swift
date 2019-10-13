//
//  AppDelegate.swift
//  GeektreeInteractor
//
//  Created by Hyeon su Ha on 13/10/2019.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow.init(frame: UIScreen.main.bounds)
    self.window?.makeKeyAndVisible()
    self.window?.rootViewController = SceneController.init()
    
    return true
  }
}

