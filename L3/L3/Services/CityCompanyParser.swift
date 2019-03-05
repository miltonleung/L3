//
//  CityCompanyParser.swift
//  L3
//
//  Created by Milton Leung on 2019-03-04.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

final class CityCompanyeParser {
  func parse(from json: JSON) -> CityCompany? {
    guard
      let name = json["name"] as? String,
      let size = json["size"] as? Int,
      let addresses = json["addresses"] as? JSON
      let streetAddresses = addresses["street"] as? [String],
      let coordinates = addresses["coordinates"] as? JSON
      else { return nil }


    var imageURL: URL? = nil
    if let imageURLString = json["photo_url"] as? String {
      imageURL = URL(string: imageURLString)
    }

    var numbeoURL: URL? = nil
    var averageMonthlySalary: Double? = nil
    var averageMonthlyRent: Double? = nil
    if
      let numbeoURLString = json["url"] as? String,
      let numbeoURLValue = URL(string: numbeoURLString),
      let averageMonthlySalaryValue = json["average_salary"] as? Double,
      let averageMonthlyRentValue = json["average_rent"] as? Double {
      numbeoURL = numbeoURLValue
      averageMonthlySalary = averageMonthlySalaryValue
      averageMonthlyRent = averageMonthlyRentValue
    }

    var costOfLivingIndex: Double? = nil
    var rentIndex: Double? = nil
    var groceriesIndex: Double? = nil
    if
      let costOfLivingIndexValue = json["average_salary"] as? Double,
      let rentIndexValue = json["average_rent"] as? Double,
      let groceriesIndexValue = json["groceries_index"] as? Double {
      costOfLivingIndex = costOfLivingIndexValue
      rentIndex = rentIndexValue
      groceriesIndex = groceriesIndexValue
    }


    return Location(name: name,
                    averageDevSalary: averageDevSalary,
                    latitude: latitude,
                    longitude: longitude,
                    sizeIndex: sizeIndex,
                    glassdoorURL: glassdoorURL,
                    averageMonthlyRent: averageMonthlyRent,
                    averageMonthlySalary: averageMonthlySalary,
                    costOfLivingIndex: costOfLivingIndex,
                    rentIndex: rentIndex,
                    groceriesIndex: groceriesIndex,
                    numbeoURL: numbeoURL,
                    imageURL: imageURL)
  }}

final class CityCompaniesParser {
  func parse(from jsonArray: [JSON]) -> [CityCompany] {
    let parser = CityCompanyParser()
    return jsonArray.compactMap { parser.parse(from: $0) }
  }
}

