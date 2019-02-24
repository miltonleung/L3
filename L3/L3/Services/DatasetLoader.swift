//
//  DatasetLoader.swift
//  L3
//
//  Created by Milton Leung on 2019-02-23.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

final class DatasetLoader {
  private func decode<T: Decodable>(at url: URL) throws -> [T] {
    let json = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([T].self, from: json)
    return decoded
  }

  lazy var restaurants: [RestaurantResult] = {
    guard let url = Bundle.main.url(forResource: "vancouver_09_06_18", withExtension: "json") else { return [] }
    do {
      return try decode(at: url)
    } catch {
      print(error)
      return []
    }
  }()

  lazy var dishTypes: [DishType] = {
    guard let url = Bundle.main.url(forResource: "dish_categories", withExtension: "json") else { return [] }

    do {
      let jsonData = try Data(contentsOf: url)
      guard let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>,
        let dishTypes = json["dish_categories"] as? [String] else { return [] }
      return dishTypes.compactMap { DishType(name: $0) }
    } catch {
      print(error)
      return []
    }
  }()
}
