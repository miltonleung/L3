//
//  CityViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol CityViewModel {
  var numberOfStatistics: Int { get }

  var cityHeaderCellViewModel: CityHeaderCellViewModel { get }
  var cityImageCellViewModel: CityImageCellViewModel { get }
  var cityStatisticsCellViewModel: CityStatisticsCellViewModel { get }
}

final class CityViewModelImpl {
  fileprivate let location: Location
  fileprivate let rank: Int

  init(location: Location, rank: Int) {
    self.location = location
    self.rank = rank
  }

  // Coordinator Handlers


  // View Controller Handlers

}

extension CityViewModelImpl: CityViewModel {
  var numberOfStatistics: Int {
    return location.statistics.count
  }

  var cityHeaderCellViewModel: CityHeaderCellViewModel {
    return CityHeaderCellViewModelImpl(rank: rank, cityName: location.name)
  }

  var cityImageCellViewModel: CityImageCellViewModel {
    return CityImageCellViewModelImpl(imageURL: nil)
  }

  var cityStatisticsCellViewModel: CityStatisticsCellViewModel {
    return CityStatisticsCellViewModelImpl(statistics: location.statistics)
  }
}
