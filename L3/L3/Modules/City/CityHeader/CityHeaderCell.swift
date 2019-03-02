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
  }

  func applyStyling() {
    rankLabel.textColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
    rankLabel.font = Font.medium(size: 19)

    cityLabel.textColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
    cityLabel.font = Font.bold(size: 24)

    backgroundColor = .clear
    selectionStyle = .none
  }
}
