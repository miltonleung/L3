//
//  DatasetLoader.swift
//  L3
//
//  Created by Milton Leung on 2019-02-23.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

final class DatasetLoader {
  lazy var locations: [Location] = {
    guard let url = Bundle.main.url(forResource: "master_locations", withExtension: "json") else { return [] }
    do {
      let data = try Data(contentsOf: url)
      let jsonObjectRaw = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
      guard let jsonObject = jsonObjectRaw as? [JSON] else { return [] }

      return LocationsParser().parse(from: jsonObject)
    } catch {
      print(error)
      return []
    }
  }()
}
