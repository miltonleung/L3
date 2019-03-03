//
//  CityImageCell.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit
import Kingfisher

final class CityImageCell: UITableViewCell {
  @IBOutlet weak var cityImageView: UIImageView!

  var viewModel: CityImageCellViewModel!

  func configure(viewModel: CityImageCellViewModel) {
    self.viewModel = viewModel
    cityImageView.kf.setImage(with: viewModel.imageURL)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    applyStyling()
  }

  func applyStyling() {
    backgroundColor = .clear
    selectionStyle = .none
    
    cityImageView.contentMode = .scaleAspectFill
    cityImageView.layer.cornerRadius = 5
    cityImageView.layer.masksToBounds = true
  }
}
