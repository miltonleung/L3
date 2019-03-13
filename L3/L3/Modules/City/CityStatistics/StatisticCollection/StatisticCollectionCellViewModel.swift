//
//  StatisticCollectionCellViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol StatisticCollectionCellViewModel {
  var categoryText: String { get }
  var valueText: String { get }
}

final class StatisticCollectionCellViewModelImpl {
  let categoryText: String
  let valueText: String

  init(statistic: Statistic) {
    categoryText = statistic.category
    switch statistic {
    case .jobIndex(let value):
      valueText = value.withCommas()
    case .averageDevSalary(let value):
      valueText = String(format: "$%.01fk", value / 1000)
    case .averageSalary(let value):
      valueText = String(format: "$%.01fk", value / 1000)
    case .costOfLiving(let value):
      valueText = "\(value)"
    case .rent(let value):
      valueText = "$\(Int(value))"
    case .groceries(let value):
      valueText = "\(value)"
    case .averageAdjustedDevSalary(let value):
      valueText = String(format: "$%.01fk", value / 1000)
    }
  }

  // Coordinator Handlers


  // View Controller Handlers

}

extension StatisticCollectionCellViewModelImpl: StatisticCollectionCellViewModel {

}
