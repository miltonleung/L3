//
//  UserDefaultsManager.swift
//  L3
//
//  Created by Milton Leung on 2019-03-05.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

final internal class UserDefaultsManager {
  let defaults: UserDefaults = .standard
}

extension UserDefaultsManager {
  func getTheme() -> Theme {
    let themeString = defaults.string(forKey: "theme") ?? ""
    return Theme.instantiate(string: themeString)
  }

  func setTheme(theme: Theme) {
    defaults.set(theme.rawValue, forKey: "theme")
  }
}
