//
//  CityHeaderCell.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

final class CityHeaderCell: UITableViewCell {
  @IBOutlet weak var rankLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!

  var viewModel: CityHeaderCellViewModel!

  func configure(viewModel: CityHeaderCellViewModel) {
    self.viewModel = viewModel
    rankLabel.text = viewModel.rankText
    cityLabel.text = viewModel.cityName
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
    rankLabel.font = Font.medium(size: 19)

    cityLabel.font = Font.bold(size: 24)

    backgroundColor = .clear
    selectionStyle = .none
  }
}

extension CityHeaderCell: Themeable {
  func onThemeChanged(theme: Theme) {
    switch theme {
    case .dark:
      rankLabel.textColor = Colors.darkSubheader
      cityLabel.textColor = Colors.darkTitle
    case .light:
      rankLabel.textColor = Colors.lightSubheader
      cityLabel.textColor = Colors.lightTitle
    }
  }
}
