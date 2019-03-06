//
//  CityCompanyHeaderCell.swift
//  L3
//
//  Created by Milton Leung on 2019-03-05.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

final class CityCompanyHeaderCell: UITableViewCell {
  @IBOutlet weak var headerLabel: UILabel!

  var viewModel: CityCompanyHeaderCellViewModel!

  func configure(viewModel: CityCompanyHeaderCellViewModel) {
    self.viewModel = viewModel
    headerLabel.text = viewModel.headerLabelText
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    applyStyling()
    setupTheme()
  }

  deinit {
    stopObservingTheme()
  }

  func applyStyling() {
    backgroundColor = .clear
    selectionStyle = .none

    headerLabel.font = Font.bold(size: 18)
  }
}

extension CityCompanyHeaderCell: Themeable {
  func onThemeChanged(theme: Theme) {
    switch theme {
    case .dark:
      headerLabel.textColor = Colors.darkSectionHeader
    case .light:
      headerLabel.textColor = Colors.lightSectionHeader
    }
  }
}
