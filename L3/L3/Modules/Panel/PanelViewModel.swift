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
  var adjustedDevSalaryButtonTitle: String { get }
  var selectedButton: LocationFilter { get }
  var exploreButtonTitle: String { get }

  func locationFilterTapped(filter: LocationFilter)

  var onLocationFilterTapped: ((LocationFilter) -> Void)? { get set }
  var onExploreButtonTapped: (() -> Void)? { get set }
}

final class PanelViewModelImpl {
  let title = "Explore based on"
  let numberOfJobsButtonTitle = "Number Of Jobs"
  let devSalaryButtonTitle = "Dev Salary"
  let monthlyRentButtonTitle = "Rent"
  let adjustedDevSalaryButtonTitle = "Adjusted Dev Salary"
  let exploreButtonTitle = "Explore"

  fileprivate var isNumberOfJobsSelected = true
  fileprivate var isDevSalarySelected = false
  fileprivate var isMonthlyRentSelected = false
  fileprivate var isAdjustedDevSalarySelected = false

  // Coordinator Handlers
  var onLocationFilterTapped: ((LocationFilter) -> Void)?
  var onExploreButtonTapped: (() -> Void)?

  // View Controller Handlers
}

extension PanelViewModelImpl: PanelViewModel {
  var selectedButton: LocationFilter {
    if isNumberOfJobsSelected {
      return .sizeIndex
    } else if isDevSalarySelected {
      return .averageDevSalary
    } else if isMonthlyRentSelected{
      return .averageMonthlyRent
    } else {
      return .averageAdjustedDevSalary
    }
  }

  func locationFilterTapped(filter: LocationFilter) {
    switch filter {
    case .sizeIndex:
      guard isNumberOfJobsSelected == false else { return }
      isNumberOfJobsSelected = true
      isDevSalarySelected = false
      isMonthlyRentSelected = false
      isAdjustedDevSalarySelected = false
    case .averageDevSalary:
      guard isDevSalarySelected == false else { return }
      isNumberOfJobsSelected = false
      isDevSalarySelected = true
      isMonthlyRentSelected = false
      isAdjustedDevSalarySelected = false
    case .averageMonthlyRent:
      guard isMonthlyRentSelected == false else { return }
      isNumberOfJobsSelected = false
      isDevSalarySelected = false
      isMonthlyRentSelected = true
      isAdjustedDevSalarySelected = false
    case .averageAdjustedDevSalary:
      guard isAdjustedDevSalarySelected == false else { return }
      isNumberOfJobsSelected = false
      isDevSalarySelected = false
      isMonthlyRentSelected = false
      isAdjustedDevSalarySelected = true
    }
    onLocationFilterTapped?(filter)
  }
}
