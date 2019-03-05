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
  }

  func applyStyling() {
    backgroundColor = .clear
    selectionStyle = .none

    headerLabel.font = Font.bold(size: 18)
    headerLabel.textColor = #colorLiteral(red: 0.4274509804, green: 0.4274509804, blue: 0.4274509804, alpha: 1)
  }
}
