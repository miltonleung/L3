//
//  CityStatisticsViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

protocol CityStatisticsCellViewModel {
  var numberOfStatistics: Int { get }

  func itemViewModel(at indexPath: IndexPath) -> StatisticCollectionCellViewModel
}

final class CityStatisticsCellViewModelImpl {

  let statistics: [Statistic]

  init(statistics: [Statistic]) {
    self.statistics = statistics
  }

  // Coordinator Handlers


  // View Controller Handlers

}

extension CityStatisticsCellViewModelImpl: CityStatisticsCellViewModel {
  var numberOfStatistics: Int {
    return statistics.count
  }

  func itemViewModel(at indexPath: IndexPath) -> StatisticCollectionCellViewModel {
    return StatisticCollectionCellViewModelImpl(statistic: statistics[indexPath.item])
  }
}
