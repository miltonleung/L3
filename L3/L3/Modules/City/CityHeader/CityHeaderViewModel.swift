//
//  CityHeaderViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol CityHeaderCellViewModel {
  var rankText: String { get }
  var cityName: String { get }
}

final class CityHeaderCellViewModelImpl {
  let rankText: String
  let cityName: String

  init(rank: Int, cityName: String) {
    self.rankText = "#\(rank)"
    self.cityName = cityName
  }

  // Coordinator Handlers


  // View Controller Handlers

}

extension CityHeaderCellViewModelImpl: CityHeaderCellViewModel {

}
