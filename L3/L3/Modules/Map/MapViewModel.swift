//
//  MapViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

protocol MapViewModel {
  var locations: [Location] { get }
  var locationFilter: LocationFilter { get }
  var panelCoordinator: PanelCoordinator { get }

  func setCoordinatorDelegate()
  func fetchLocations()

  var onLocationsUpdated: (() -> Void)? { get set }
}

final class MapViewModelImpl {
  let datasetLoader = DatasetLoader()
  let panelCoordinator: PanelCoordinator

  var locations: [Location] = [] {
    didSet {
      onLocationsUpdated?()
    }
  }

  var locationFilter: LocationFilter = .sizeIndex

  init() {
    self.panelCoordinator = PanelCoordinator(navigationController: UINavigationController())
  }

  // Coordinator Handlers


  // View Controller Handlers
  var onLocationsUpdated: (() -> Void)?
}

extension MapViewModelImpl: MapViewModel {
  func setCoordinatorDelegate() {
    self.panelCoordinator.delegate = self
  }

  func fetchLocations() {
    self.locations = datasetLoader.sortedLocations(by: locationFilter)
      //    print(locations.filter { $0.averageDevSalary/maxValue >= 0.85 }
  }
}

extension MapViewModelImpl: PanelCoordinatorDelegate {
  func locationFilterChanged(filter: LocationFilter) {
    self.locationFilter = filter
    self.locations = datasetLoader.sortedLocations(by: locationFilter)
  }
}
