//
//  CityCompany.swift
//  L3
//
//  Created by Milton Leung on 2019-03-04.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

struct Address: Equatable {
  let street: String
  let lat: Double
  let long: Double
}

struct CityCompany: Equatable {
  let name: String
  let size: Int
  let addresses: [Address]
}
