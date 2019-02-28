//
//  ContentCoordinator.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

protocol ContentCoordinatorDelegate: class {
  func contentCoordinatorDidFinish(_ coordinator: ContentCoordinator)
}

final class ContentCoordinator: Coordinator {
  fileprivate weak var delegate: ContentCoordinatorDelegate?
  var rootViewController: UIViewController?


  init(delegate: ContentCoordinatorDelegate) {
    self.delegate = delegate
  }

  func start() {
    let viewModel = MapViewModelImpl()
    let mapViewController = MapViewController(viewModel: viewModel)
    rootViewController = mapViewController
  }
}
