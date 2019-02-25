//
//  Location.swift
//  L3
//
//  Created by Milton Leung on 2019-02-23.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

enum LocationSort {
  case sizeIndex, averageDevSalary, averageMonthlyRent
}

struct Location {
  let name: String
  let averageDevSalary: Double
  let latitude: Double
  let longitude: Double
  let sizeIndex: Int
  let glassdoorURL: URL
  let averageMonthlyRent: Double?
  let averageMonthlySalary: Double?
  let costOfLivingIndex: Double?
  let rentIndex: Double?
  let groceriesIndex: Double?
  let numbeoURL: URL?
}

extension Location {
  var averageSalary: Double? {
    guard let averageMonthlySalary = averageMonthlySalary else { return nil }
    return averageMonthlySalary * 12
  }
}
