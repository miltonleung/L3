//
//  CityCompanyCollectionCellViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-05.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol CityCompanyCollectionCellViewModel {
  var companyName: String { get }
}

final class CityCompanyCollectionCellViewModelImpl {
  let companyName: String

  init(companyName: String) {
    self.companyName = companyName
  }

  // Coordinator Handlers


  // View Controller Handlers

}

extension CityCompanyCollectionCellViewModelImpl: CityCompanyCollectionCellViewModel {

}
