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
  }

  func applyStyling() {
    categoryLabel.textColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
    categoryLabel.font = Font.bold(size: 11)

    valueLabel.textColor = #colorLiteral(red: 0.1529411765, green: 0.3921568627, blue: 0.8470588235, alpha: 1)
    valueLabel.font = Font.medium(size: 26)
  }
}
