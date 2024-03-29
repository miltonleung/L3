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
  func cityDismissed()
  func allCitiesDismissed()
  func cityCompanySelected(company: CityCompany)
}

final class PanelCoordinator: NSObject, Coordinator {
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

    navigationController.delegate = self
    navigationController.viewControllers = [panelVC]
    navigationController.setNavigationBarHidden(true, animated: false)
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
    viewModel.onBackPanned = {
      self.delegate?.cityDismissed()
      self.navigationController.popViewController(animated: true)
      print(self.navigationController.viewControllers)
    }
    viewModel.onCloseTapped = {
      self.delegate?.allCitiesDismissed()
      self.navigationController.popToRootViewController(animated: true)
    }
    viewModel.onCityCompanySelected = { cityCompany in
      self.delegate?.cityCompanySelected(company: cityCompany)
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

extension PanelCoordinator: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PanelAnimationController(operation: operation, duration: navigationController.transitionCoordinator?.transitionDuration)
  }
}
