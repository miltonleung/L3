//
//  CityCompanyCollectionCell.swift
//  L3
//
//  Created by Milton Leung on 2019-03-05.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

final class CityCompanyCollectionCell: UICollectionViewCell {
  @IBOutlet weak var companyLabel: UILabel!

  var viewModel: CityCompanyCollectionCellViewModel!

  func configure(viewModel: CityCompanyCollectionCellViewModel) {
    self.viewModel = viewModel
    companyLabel.text = viewModel.companyName
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
    companyLabel.font = Font.bold(size: 18)
    companyLabel.textColor = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
  }
}

extension CityCompanyCollectionCell: Themeable {
  func onThemeChanged(theme: Theme) {
    switch theme {
    case .dark:
      companyLabel.textColor = Colors.darkLightText
    case .light:
      companyLabel.textColor = Colors.lightDarkText
    }
  }
}
