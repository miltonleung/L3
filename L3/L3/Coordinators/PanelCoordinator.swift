//
//  PanelCoordinator.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

protocol PanelCoordinatorDelegate: class {
  
}

final class PanelCoordinator: Coordinator {
  weak var delegate: PanelCoordinatorDelegate?
  let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let panelViewModel = PanelViewModelImpl()
    let panelVC = PanelViewController(viewModel: panelViewModel)

    navigationController.viewControllers = [panelVC]
    navigationController.setNavigationBarHidden(true, animated: false)
  }
}

