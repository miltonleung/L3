//
//  LocationParser.swift
//  L3
//
//  Created by Milton Leung on 2019-02-23.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

final class LocationParser {
  func parse(from json: JSON) -> Location? {
    guard
      let name = json["name"] as? String,
      let averageDevSalary = json["avg_swe_salary_usd"] as? Double,
      let coordinates = json["coordinates"] as? JSON,
      let latitude = coordinates["lat"] as? Double,
      let longitude = coordinates["long"] as? Double,
      let sizeIndex = json["sizeIndex"] as? Int,
      let glassdoorURLString = json["salary_page"] as? String,
      let glassdoorURL = URL(string: glassdoorURLString),
      let companiesJSON = json["companies"] as? [JSON]
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
    var averageRent: Double? = nil
    var groceriesIndex: Double? = nil
    if
      let costOfLivingIndexValue = json["average_salary"] as? Double,
      let averageRentValue = json["average_rent"] as? Double,
      let groceriesIndexValue = json["groceries_index"] as? Double {
      costOfLivingIndex = costOfLivingIndexValue
      averageRent = averageRentValue
      groceriesIndex = groceriesIndexValue
    }

    var averageAdjustedDevSalary: Double? = nil
    if let averageAdjustedDevSalaryValue = json["swe_salary_after_tax_rent"] as? Double {
      averageAdjustedDevSalary = averageAdjustedDevSalaryValue
    }

    let cityCompaniesParser = CityCompaniesParser()
    let companies = cityCompaniesParser.parse(from: companiesJSON)

    return Location(name: name,
                    averageDevSalary: averageDevSalary,
                    latitude: latitude,
                    longitude: longitude,
                    sizeIndex: sizeIndex,
                    glassdoorURL: glassdoorURL,
                    averageMonthlyRent: averageMonthlyRent,
                    averageMonthlySalary: averageMonthlySalary,
                    costOfLivingIndex: costOfLivingIndex,
                    averageRent: averageRent,
                    groceriesIndex: groceriesIndex,
                    numbeoURL: numbeoURL,
                    imageURL: imageURL,
                    companies: companies,
                    averageAdjustedDevSalary: averageAdjustedDevSalary)
  }}

final class LocationsParser {
  func parse(from jsonArray: [JSON]) -> [Location] {
    let parser = LocationParser()
    return jsonArray.compactMap { parser.parse(from: $0) }
  }
}
