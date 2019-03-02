//
//  UITableView+Nib.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

extension UITableView {
  func register<T: UITableViewCell>(_: T.Type) {
    self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))
  }
}
