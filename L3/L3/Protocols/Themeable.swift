//
//  Themeable.swift
//  
//
//  Created by Milton Leung on 2019-03-05.
//

import Foundation
import UIKit

protocol Themeable: class {
  var currentTheme: Theme { get }
  func setupTheme()
  func stopObservingTheme()
  func onThemeChanged(theme: Theme)
}

extension Themeable {
  var currentTheme: Theme {
    return ThemeManager.shared.getCurrentTheme()
  }
  
  func setupTheme() {
    onThemeChanged(theme: ThemeManager.shared.getCurrentTheme())
    ThemeManager.shared.subscribeForChanges(self) { [weak self] theme in
      self?.onThemeChanged(theme: theme)
    }
  }

  func stopObservingTheme() {
    ThemeManager.shared.stopObserving(self)
  }
}
