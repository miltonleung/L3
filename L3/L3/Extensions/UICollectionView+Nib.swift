//
//  UICollectionView+Nib.swift
//  L3
//
//  Created by Milton Leung on 2019-03-02.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

extension UICollectionView {
  func register<T: UICollectionViewCell>(_: T.Type) {
    self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: String(describing: T.self))
  }
}
