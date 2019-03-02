//
//  Int+Commas.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

extension Int {
  func withCommas() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
  }
}
