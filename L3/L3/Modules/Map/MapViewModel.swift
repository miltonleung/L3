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
  var aboutText: NSAttributedString { get }
  var infoText: NSAttributedString { get }

  func setCoordinatorDelegate()
  func fetchLocations()
  func locationTapped(location: Location)

  var onLocationsUpdated: (() -> Void)? { get set }
  var onCameraChange: ((Location) -> Void)? { get set }
  var onEmptyCities: (() -> Void)? { get set }
  var onCityCompanySelected: ((CityCompany) -> Void)? { get set }
}

final class MapViewModelImpl {
  let datasetLoader = DatasetLoader()
  let textLoader = TextLoader()
  let panelCoordinator: PanelCoordinator

  var locations: [Location] = [] {
    didSet {
      onLocationsUpdated?()
    }
  }

  var locationFilter: LocationFilter = .sizeIndex
  var locationStack: [Int] = [] {
    didSet {
      if locationStack.isEmpty {
        onEmptyCities?()
      }
    }
  }

  init() {
    self.panelCoordinator = PanelCoordinator(navigationController: UINavigationController())
  }

  // Coordinator Handlers


  // View Controller Handlers
  var onLocationsUpdated: (() -> Void)?
  var onCameraChange: ((Location) -> Void)?
  var onEmptyCities: (() -> Void)?
  var onCityCompanySelected: ((CityCompany) -> Void)?
}

extension MapViewModelImpl: MapViewModel {
  func setCoordinatorDelegate() {
    self.panelCoordinator.delegate = self
  }

  func fetchLocations() {
    self.locations = datasetLoader.sortedLocations(by: locationFilter)
  }

  func locationTapped(location: Location) {
    guard let index = locations.firstIndex(where: { $0 == location }) else { return }

    if
      !locationStack.isEmpty,
      let currentLocation = locationStack.last,
      currentLocation == index { return }

    locationStack.append(index)
    nextCity()
  }

  var aboutText: NSAttributedString {
    return textLoader.aboutAttributed
  }

  var infoText: NSAttributedString {
    return textLoader.infoAttributed
  }
}

extension MapViewModelImpl: PanelCoordinatorDelegate {
  func locationFilterChanged(filter: LocationFilter) {
    self.locationFilter = filter
    self.locations = datasetLoader.sortedLocations(by: locationFilter)
  }

  func exploreTapped() {
    locationStack.append(0)
    nextCity()
  }

  func actionTapped() {
    guard
      let currentLocation = locationStack.last,
      currentLocation + 1 <= locations.count else { return }
    locationStack.append(currentLocation + 1)
    nextCity()
  }

  private func nextCity() {
    guard let currentLocation = locationStack.last else { return }
    panelCoordinator.showCity(location: locations[currentLocation], rank: currentLocation + 1, isLast: currentLocation == locations.count - 1)
    onCameraChange?(locations[currentLocation])
  }

  func cityDismissed() {
    _ = locationStack.removeLast()
    guard let currentLocation = locationStack.last else { return }
    onCameraChange?(locations[currentLocation])
  }

  func allCitiesDismissed() {
    locationStack.removeAll()
  }

  func cityCompanySelected(company: CityCompany) {
    onCityCompanySelected?(company)
  }
}
