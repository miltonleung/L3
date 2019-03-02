//
//  Font.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

internal struct Font {
  static func bold(size: CGFloat) -> UIFont {
    return UIFont(name: "CircularStd-Bold", size: size)!
  }

  static func regular(size: CGFloat) -> UIFont {
    return UIFont(name: "CircularStd-Book", size: size)!
  }

  static func medium(size: CGFloat) -> UIFont {
    return UIFont(name: "CircularStd-Medium", size: size)!
  }
}
