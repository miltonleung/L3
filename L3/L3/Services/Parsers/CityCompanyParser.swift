//
//  CityCompanyParser.swift
//  L3
//
//  Created by Milton Leung on 2019-03-04.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

final class CityCompanyParser {
  func parse(from json: JSON) -> CityCompany? {
    guard
      let name = json["name"] as? String,
      let size = json["size"] as? Int,
      let addressesJSON = json["addresses"] as? JSON,
      let streetAddresses = addressesJSON["street"] as? [String],
      let coordinates = addressesJSON["coordinates"] as? [JSON]
      else { return nil }

    var addresses: [Address] = []

    if streetAddresses.count == coordinates.count {
      for i in 0..<streetAddresses.count {
        guard
          let lat = coordinates[i]["lat"] as? Double,
          let long = coordinates[i]["long"] as? Double
          else { continue }

        addresses.append(Address(street: streetAddresses[i], lat: lat, long: long))
      }
    }

    return CityCompany(name: name,
                       size: size,
                       addresses: addresses)

  }
}

final class CityCompaniesParser {
  func parse(from jsonArray: [JSON]) -> [CityCompany] {
    let parser = CityCompanyParser()
    return jsonArray.compactMap { parser.parse(from: $0) }
  }
}

