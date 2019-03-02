//
//  PanelViewModel.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright (c) 2019 ms. All rights reserved.
//

protocol PanelViewModel {
  var title: String { get }
  var numberOfJobsButtonTitle: String { get }
  var devSalaryButtonTitle: String { get }
  var monthlyRentButtonTitle: String { get }
  var exploreButtonTitle: String { get }

  func locationFilterTapped(filter: LocationFilter)

  var onLocationFilterTapped: ((LocationFilter) -> Void)? { get set }
}

final class PanelViewModelImpl {
  let title = "Explore based on"
  let numberOfJobsButtonTitle = "Number Of Jobs"
  let devSalaryButtonTitle = "Dev Salary"
  let monthlyRentButtonTitle = "Monthly Rent"
  let exploreButtonTitle = "Explore"

  fileprivate var isNumberOfJobsSelected = false
  fileprivate var isDevSalarySelected = false
  fileprivate var isMonthlyRentSelected = false

  // Coordinator Handlers
  var onLocationFilterTapped: ((LocationFilter) -> Void)?

  // View Controller Handlers
}

extension PanelViewModelImpl: PanelViewModel {
  func locationFilterTapped(filter: LocationFilter) {
    switch filter {
    case .sizeIndex:
      guard isNumberOfJobsSelected == false else { return }
      isNumberOfJobsSelected = true
      isDevSalarySelected = false
      isMonthlyRentSelected = false

    case .averageDevSalary:
      guard isDevSalarySelected == false else { return }
      isNumberOfJobsSelected = false
      isDevSalarySelected = true
      isMonthlyRentSelected = false

    case .averageMonthlyRent:
      guard isMonthlyRentSelected == false else { return }
      isNumberOfJobsSelected = false
      isDevSalarySelected = false
      isMonthlyRentSelected = true
    }
    onLocationFilterTapped?(filter)
  }
}
