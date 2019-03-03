//
//  CityActionViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-03-02.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol CityActionCellViewModel {
  var actionButtonTitle: String { get }

  var onActionButtonTapped: (() -> Void)? { get set }
}

final class CityActionCellViewModelImpl {
  let actionButtonTitle: String

  init(isLast: Bool) {
    actionButtonTitle = isLast ? "Done" : "Next City"
  }

  // Coordinator Handlers
  var onActionButtonTapped: (() -> Void)?

  // View Controller Handlers

}

extension CityActionCellViewModelImpl: CityActionCellViewModel {

}
