//
//  DatasetLoader.swift
//  L3
//
//  Created by Milton Leung on 2019-02-23.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

final class DatasetLoader {
  private lazy var locations: [Location] = {
    guard let url = Bundle.main.url(forResource: "master_locations", withExtension: "json") else { return [] }
    do {
      let data = try Data(contentsOf: url)
      let jsonObjectRaw = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
      guard let jsonObject = jsonObjectRaw as? [JSON] else { return [] }

      return LocationsParser().parse(from: jsonObject)
    } catch {
      print(error)
      return []
    }
  }()

  private lazy var sortedLocationsDevSalary: [Location] = {
    return locations.sorted(by: { $0.averageDevSalary > $1.averageDevSalary })
  }()

  private lazy var sortedLocationsRent: [Location] = {
    var unavailable: [Location] = []

    var sortedLocations = locations
      .filter { location in
        if location.averageMonthlyRent != nil {
          return true
        }
        unavailable.append(location)
        return false
      }.sorted(by: { lhs, rhs in
        guard let lhsRent = lhs.averageMonthlyRent, let rhsRent = rhs.averageMonthlyRent else { return true }
        return lhsRent > rhsRent
      })

    return sortedLocations + unavailable
  }()

  private lazy var sortedLocationsAdjustedDevSalary: [Location] = {
    var unavailable: [Location] = []

    var sortedLocations = locations
      .filter { location in
        if location.averageAdjustedDevSalary != nil {
          return true
        }
        unavailable.append(location)
        return false
      }.sorted(by: { lhs, rhs in
        guard let lhsSalary = lhs.averageAdjustedDevSalary, let rhsSalary = rhs.averageAdjustedDevSalary else { return true }
        return lhsSalary > rhsSalary
      })

    return sortedLocations + unavailable
  }()

  func sortedLocations(by sortType: LocationFilter = .sizeIndex) -> [Location] {
    switch sortType {
    case .sizeIndex:
      return locations
    case .averageDevSalary:
      return sortedLocationsDevSalary
    case .averageMonthlyRent:
      return sortedLocationsRent
    case .averageAdjustedDevSalary:
      return sortedLocationsAdjustedDevSalary
    }
  }
}
