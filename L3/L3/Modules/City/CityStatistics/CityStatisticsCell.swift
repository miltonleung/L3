//
//  CityStatisticsCell.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

final class CityStatisticsCell: UITableViewCell {
  struct Constants {
    static let cellHeight: CGFloat = 63
    static let verticalPadding: CGFloat = 38
  }
  @IBOutlet weak var dividerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.register(StatisticCollectionCell.self)
    }
  }

  var viewModel: CityStatisticsCellViewModel!

  func configure(viewModel: CityStatisticsCellViewModel) {
    self.viewModel = viewModel
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    applyStyling()
  }

  func applyStyling() {
    backgroundColor = .clear
    selectionStyle = .none

    dividerView.backgroundColor = Colors.divider

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isScrollEnabled = false
    collectionView.backgroundColor = .clear
  }
}

extension CityStatisticsCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfStatistics
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StatisticCollectionCell.self), for: indexPath) as? StatisticCollectionCell else { fatalError() }
    cell.configure(viewModel: viewModel.itemViewModel(at: indexPath))
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

extension CityStatisticsCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width / 2, height: Constants.cellHeight)
  }
}
