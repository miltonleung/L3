//
//  CityActionCell.swift
//  L3
//
//  Created by Milton Leung on 2019-03-02.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit
import ChameleonFramework

final class CityActionCell: UITableViewCell {
  @IBOutlet weak var actionButton: UIButton!

  var viewModel: CityActionCellViewModel!

  func configure(viewModel: CityActionCellViewModel) {
    self.viewModel = viewModel
    actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    applyStyling()
  }

  func applyStyling() {
    backgroundColor = .clear
    selectionStyle = .none

    actionButton.titleLabel?.font = Font.bold(size: 18)
    actionButton.setTitleColor(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1), for: .normal)
    actionButton.layer.cornerRadius = 8
    actionButton.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: actionButton.frame, andColors: [#colorLiteral(red: 0.7490196078, green: 0.3058823529, blue: 0.4823529412, alpha: 0.85), #colorLiteral(red: 0.7529411765, green: 0.2980392157, blue: 0.4470588235, alpha: 0.85)])
  }
}

// MARK: IBActions
extension CityActionCell {
  @IBAction private func actionButtonTapped() {
    viewModel.onActionButtonTapped?()
  }
}
