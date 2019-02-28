//
//  AppDelegate.swift
//  L3
//
//  Created by Milton Leung on 2019-02-20.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow()
    let coordinator = AppCoordinator(window: window)
    coordinator.start()
    self.window = window

    return true
  }
}

