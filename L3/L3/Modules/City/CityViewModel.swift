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
  var cityActionCellViewModel: CityActionCellViewModel { get }
}

final class CityViewModelImpl {
  fileprivate let location: Location
  fileprivate let rank: Int
  fileprivate let isLast: Bool

  init(location: Location, rank: Int, isLast: Bool) {
    self.location = location
    self.rank = rank
    self.isLast = isLast
  }

  // Coordinator Handlers
  var onActionTapped: (() -> Void)?

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

  var cityActionCellViewModel: CityActionCellViewModel {
    let viewModel = CityActionCellViewModelImpl(isLast: isLast)
    viewModel.onActionButtonTapped = onActionTapped
    return viewModel
  }
}
