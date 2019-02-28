//
//  AppCoordinator.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
  fileprivate var currentCoordinator: Coordinator?

  fileprivate let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    showContent()
    window.makeKeyAndVisible()
  }
}

extension AppCoordinator {
  func showContent() {
    let contentCoordinator = ContentCoordinator(delegate: self)
    contentCoordinator.start()
    currentCoordinator = contentCoordinator
    window.rootViewController = contentCoordinator.rootViewController
  }
}

extension AppCoordinator: ContentCoordinatorDelegate {
  func contentCoordinatorDidFinish(_ coordinator: ContentCoordinator) {
    // Content should not finish
  }
}

