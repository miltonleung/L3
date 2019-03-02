//
//  Location.swift
//  L3
//
//  Created by Milton Leung on 2019-02-23.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

enum LocationFilter {
  case sizeIndex, averageDevSalary, averageMonthlyRent
}

enum Statistic {
  case jobIndex(value: Int)
  case averageDevSalary(value: Double)
  case averageSalary(value: Double)
  case costOfLiving(value: Double)
  case rent(value: Double)
  case groceries(value: Double)

  var category: String {
    switch self {
    case .jobIndex: return "JOB INDEX"
    case .averageDevSalary: return "AVG DEV SALARY"
    case .averageSalary: return "AVG SALARY"
    case .costOfLiving: return "COST OF LIVING"
    case .rent: return "RENT INDEX"
    case .groceries: return "GROCERIES INDEX"
    }
  }
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

  var statistics: [Statistic] {
    var statistics: [Statistic] = [
      .jobIndex(value: sizeIndex),
      .averageDevSalary(value: averageDevSalary)
    ]

    if let averageSalary = averageSalary {
      statistics.append(.averageSalary(value: averageSalary))
    }

    if let costOfLivingIndex = costOfLivingIndex {
      statistics.append(.costOfLiving(value: costOfLivingIndex))
    }

    if let rentIndex = rentIndex {
      statistics.append(.rent(value: rentIndex))
    }

    if let groceriesIndex = groceriesIndex {
      statistics.append(.groceries(value: groceriesIndex))
    }

    return statistics
  }
}
