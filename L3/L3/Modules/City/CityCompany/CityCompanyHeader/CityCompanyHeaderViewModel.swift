//
//  CityCompanyHeaderViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-05.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol CityCompanyHeaderCellViewModel {
  var headerLabelText: String { get }
}

final class CityCompanyHeaderCellViewModelImpl {
  let headerLabelText = "Notable Companies"

  // Coordinator Handlers


  // View Controller Handlers

}

extension CityCompanyHeaderCellViewModelImpl: CityCompanyHeaderCellViewModel {

}
