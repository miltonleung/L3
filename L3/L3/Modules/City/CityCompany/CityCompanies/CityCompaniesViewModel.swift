//
//  CityCompaniesViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-05.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

protocol CityCompaniesCellViewModel {
  var numberOfCompanies: Int { get }

  func itemViewModel(at indexPath: IndexPath) -> CityCompanyCollectionCellViewModel
  func didSelectItem(at indexPath: IndexPath)
}

final class CityCompaniesCellViewModelImpl {
  let cityCompanies: [CityCompany]

  init(cityCompanies: [CityCompany]) {
    self.cityCompanies = cityCompanies
  }

  // Coordinator Handlers
  var onCityCompanySelected: ((CityCompany) -> Void)?

  // View Controller Handlers

}

extension CityCompaniesCellViewModelImpl: CityCompaniesCellViewModel {
  var numberOfCompanies: Int {
    return cityCompanies.count
  }

  func itemViewModel(at indexPath: IndexPath) -> CityCompanyCollectionCellViewModel {
    return CityCompanyCollectionCellViewModelImpl(companyName: cityCompanies[indexPath.item].name)
  }

  func didSelectItem(at indexPath: IndexPath) {
    onCityCompanySelected?(cityCompanies[indexPath.item])
  }
}
