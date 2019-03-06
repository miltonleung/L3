//
//  Themeable.swift
//  
//
//  Created by Milton Leung on 2019-03-05.
//

import Foundation

protocol Themeable {
  var currentTheme: Theme { get }
  func registerForThemeChanges()
  func onThemeChanged(theme: Theme)
}

extension Themeable where Self: UIViewController {
  var currentTheme: Theme {
    return ThemeManager.shared.getTheme()
  }

  func registerForThemeChanges() {
    ThemeManager.shared.subscribeForChanges(onThemeChanged)
  }
}
