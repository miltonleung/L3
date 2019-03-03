//
//  PanelCoordinator.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

protocol PanelCoordinatorDelegate: class {
  func locationFilterChanged(filter: LocationFilter)
  func exploreTapped()
  func actionTapped()
}

final class PanelCoordinator: Coordinator {
  weak var delegate: PanelCoordinatorDelegate?
  let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let viewModel = PanelViewModelImpl()
    viewModel.onLocationFilterTapped = delegate?.locationFilterChanged(filter:)
    viewModel.onExploreButtonTapped = delegate?.exploreTapped
    let panelVC = PanelViewController(viewModel: viewModel)

    navigationController.viewControllers = [panelVC]
    navigationController.setNavigationBarHidden(true, animated: false)
    navigationController.isNavigationBarHidden = true
  }
}
// MARK: View Controller Instantiations
extension PanelCoordinator {
  func instantiateCity(location: Location, rank: Int, isLast: Bool) -> CityViewController {
    let viewModel = CityViewModelImpl(location: location, rank: rank, isLast: isLast)
    viewModel.onActionTapped = { [weak self] in
      if isLast {
        self?.navigationController.popToRootViewController(animated: true)
      } else {
        self?.delegate?.actionTapped()
      }
    }
    let vc = CityViewController(viewModel: viewModel)

    return vc
  }
}

// MARK: Routing
extension PanelCoordinator {
  func showCity(location: Location, rank: Int, isLast: Bool) {
    let vc = instantiateCity(location: location, rank: rank, isLast: isLast)
    navigationController.pushViewController(vc, animated: true)
  }
}
