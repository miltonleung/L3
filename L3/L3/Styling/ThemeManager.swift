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

internal typealias ThemeObserver = ((Theme) -> Void)?

final class ThemeManager {
  static let shared = ThemeManager()

  private let userDefaultsManager = UserDefaultsManager()

  private var currentTheme: Theme {
    didSet {
      userDefaultsManager.setTheme(theme: currentTheme)
    }
  }
  private var observers: [ObjectIdentifier: ThemeObserver] = [:]

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
    for (id, observer) in observers {
      guard let observer = observer else {
        observers.removeValue(forKey: id)
        continue
      }

      observer(currentTheme)
    }
  }

  func subscribeForChanges(_ object: Themeable, observer: ((Theme) -> Void)?) {
    let objectIdentifier = ObjectIdentifier(object)
    observers[objectIdentifier] = observer
  }

  func stopObserving(_ object: Themeable) {
    let objectIdentifier = ObjectIdentifier(object)
    observers.removeValue(forKey: objectIdentifier)
  }
}
