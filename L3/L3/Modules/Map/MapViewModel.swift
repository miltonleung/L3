//
//  MapViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol MapViewModel {
  var locations: [Location] { get }
  var locationSort: LocationSort { get }

  func fetchLocations()

  var onLocationsUpdated: (() -> Void)? { get set }
}

final class MapViewModelImpl {
  let datasetLoader = DatasetLoader()


  var locations: [Location] = [] {
    didSet {
      onLocationsUpdated?()
    }
  }

  var locationSort: LocationSort = .averageDevSalary

  // Coordinator Handlers


  // View Controller Handlers
  var onLocationsUpdated: (() -> Void)?
}

extension MapViewModelImpl: MapViewModel {
  func fetchLocations() {
    self.locations = datasetLoader.sortedLocations(by: locationSort)
      //    print(locations.filter { $0.averageDevSalary/maxValue >= 0.85 }
  }
}

