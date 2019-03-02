//
//  CityImageViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

import Foundation

protocol CityImageCellViewModel {
  var imageURL: URL? { get }
}

final class CityImageCellViewModelImpl {
  let imageURL: URL?

  init(imageURL: URL?) {
    self.imageURL = imageURL
  }

  // Coordinator Handlers


  // View Controller Handlers

}

extension CityImageCellViewModelImpl: CityImageCellViewModel {

}
