//
//  PassthroughNavigationController.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit

final class PanelView: UIView {}

final class PassthroughContainerView: UIView {
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

    var views: [UIView] = subviews

    while !views.isEmpty {
      let currentView = views.removeFirst()

      if currentView is PanelView {
        let rect = currentView.convert(currentView.bounds, to: self)
        return rect.contains(point)
      } else {
        views.append(contentsOf: currentView.subviews)
      }
    }

    return false
  }
}
