//
//  CityViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol CityViewModel {
  var isImageAvailable: Bool { get }
  var numberOfStatistics: Int { get }
  var numberOfCompanies: Int { get }
  var actionButtonTitle: String { get }

  var cityHeaderCellViewModel: CityHeaderCellViewModel { get }
  var cityImageCellViewModel: CityImageCellViewModel { get }
  var cityStatisticsCellViewModel: CityStatisticsCellViewModel { get }
  var cityCompanyHeaderViewModel: CityCompanyHeaderCellViewModel { get }
  var cityCompaniesViewModel: CityCompaniesCellViewModel { get }

  var onActionTapped: (() -> Void)? { get }
  var onBackPanned: (() -> Void)? { get }
  var onCloseTapped: (() -> Void)? { get }
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
  var onBackPanned: (() -> Void)?
  var onCloseTapped: (() -> Void)?
  var onCityCompanySelected: ((CityCompany) -> Void)?

  // View Controller Handlers

}

extension CityViewModelImpl: CityViewModel {
  var numberOfStatistics: Int {
    return location.statistics.count
  }

  var isImageAvailable: Bool {
    return location.imageURL != nil
  }

  var numberOfCompanies: Int {
    return location.notableCompanies.count
  }

  var actionButtonTitle: String {
    return isLast ? "Done" : "Next City"
  }

  var cityHeaderCellViewModel: CityHeaderCellViewModel {
    return CityHeaderCellViewModelImpl(rank: rank, cityName: location.name)
  }

  var cityImageCellViewModel: CityImageCellViewModel {
    return CityImageCellViewModelImpl(imageURL: location.imageURL)
  }

  var cityStatisticsCellViewModel: CityStatisticsCellViewModel {
    return CityStatisticsCellViewModelImpl(statistics: location.statistics)
  }

  var cityCompanyHeaderViewModel: CityCompanyHeaderCellViewModel {
    return CityCompanyHeaderCellViewModelImpl()
  }

  var cityCompaniesViewModel: CityCompaniesCellViewModel {
    let viewModel = CityCompaniesCellViewModelImpl(cityCompanies: location.notableCompanies)
    viewModel.onCityCompanySelected = onCityCompanySelected
    return viewModel
  }
}
