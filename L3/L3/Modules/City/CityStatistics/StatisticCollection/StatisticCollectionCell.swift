//
//  StatisticCollectionCell.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

final class StatisticCollectionCell: UICollectionViewCell {
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!

  var viewModel: StatisticCollectionCellViewModel!

  func configure(viewModel: StatisticCollectionCellViewModel) {
    self.viewModel = viewModel
    categoryLabel.text = viewModel.categoryText
    valueLabel.text = viewModel.valueText
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
    categoryLabel.font = Font.bold(size: 11)

    valueLabel.font = Font.medium(size: 26)
  }
}

extension StatisticCollectionCell: Themeable {
  func onThemeChanged(theme: Theme) {
    switch theme {
    case .dark:
      categoryLabel.textColor = Colors.darkSubheader
      valueLabel.textColor = Colors.darkStat
    case .light:
      categoryLabel.textColor = Colors.lightSubheader
      valueLabel.textColor = Colors.lightStat
    }
  }
}
