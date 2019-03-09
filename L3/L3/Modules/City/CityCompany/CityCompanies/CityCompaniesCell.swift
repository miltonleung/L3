//
//  CityCompaniesCell.swift
//  L3
//
//  Created by Milton Leung on 2019-03-05.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

final class CityCompaniesCell: UITableViewCell {
  struct Constants {
    static let cellHeight: CGFloat = 39
  }

  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.register(CityCompanyCollectionCell.self)
    }
  }
  
  var viewModel: CityCompaniesCellViewModel!

  func configure(viewModel: CityCompaniesCellViewModel) {
    self.viewModel = viewModel
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    applyStyling()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }

  func applyStyling() {
    backgroundColor = .clear
    selectionStyle = .none

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isScrollEnabled = false
    collectionView.backgroundColor = .clear
  }
}

extension CityCompaniesCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfCompanies
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityCompanyCollectionCell.self), for: indexPath) as? CityCompanyCollectionCell else { fatalError() }
    cell.configure(viewModel: viewModel.itemViewModel(at: indexPath))
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItem(at: indexPath)
  }
}

extension CityCompaniesCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width / 2, height: Constants.cellHeight)
  }
}
