//
//  ThemeManager.swift
//  L3
//
//  Created by Milton Leung on 2019-03-05.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

enum Theme: String {
  case light, dark

  static func instantiate(string: String) -> Theme {
    return Theme(rawValue: string) ?? .light
  }
}

final class ThemeManager {
  static let shared = ThemeManager()

  private let userDefaultsManager = UserDefaultsManager()

  private var currentTheme: Theme
  private var observers: [((Theme) -> Void)?] = []

  init() {
    currentTheme = userDefaultsManager.getTheme()
  }

  func getCurrentTheme() -> Theme {
    return currentTheme
  }

  func switchTheme() {
    switch currentTheme {
    case .light: currentTheme = .dark
    case .dark: currentTheme = .light
    }
    notifyObservers()
  }

  func notifyObservers() {
    for observer in observers {
      observer?(currentTheme)
    }
  }

  func subscribeForChanges(observer: ((Theme) -> Void)?) {
    observers.append(observer)
  }

//  func stopObserving(observer: ((Theme) -> Void)?) {
//    observers.filter { element in
//      return element != observer
//    }
//  }
}
