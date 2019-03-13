//
//  TextLoader.swift
//  L3
//
//  Created by Milton Leung on 2019-03-09.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation

final class TextLoader {
  let aboutHeader = """
  L3 stands for
  Location Location Location.


  """
  let aboutBody = """
  Home is where your job is. When coming up with this app idea, we had a lot of questions about what it was like to be a software engineer in any given city.

  Sure, everyone knows San Francisco, Silicon Valley and New York City has the biggest tech scenes. But by how much? And how much bigger is it actually than booming places like Seattle, Austin, and Salt Lake City?

  We think L3 helps us visualize this and compare cities in a beautiful and interactive way. For example, San Francisco has the highest salary but also the highest cost of living, hmmm.

  Use the map to find your next home or use it as a night lamp.

  Completed March 2019.
  Best experienced on iPad.

  Thank you Unsplash, Numbeo, and Glassdoor.

  Milton Leung
  Sarina Chen

  """

  private let infoHeader = """
  It was made to look like a Christmas tree.


  """

  private let infoBody = """
  That’s probably why it might not make sense right away. Here’s a short description of what everything means.

  \u{2022} A pulsing dot on the map indicates a significant value based on the category selected. The larger the pulse, the more significant.

  \u{2022} A city with a non-pulsing dot indicates a non-significant value.

  \u{2022} Job Index is proprietary indicator of how many large companies there are. The larger the number, the larger the companies there are.

  \u{2022} Average Dev Salary is the average salary a software engineer makes according to Glassdoor. Not senior. Not principal. Not intern.

  \u{2022} Average Salary is the average salary of all residents in that location.

  \u{2022} Cost of Living is based on the index kept by Numbeo. It includes factors like prices at restaurants, groceries, transporation, & utilities. The value is relative to NYC, so NYC is 100.0.

  \u{2022} Average Rent is the average rent of a 1 bedroom apartment in the city center.

  \u{2022} Adjusted Dev Salary is the average salary minus income tax and rent for the entire year.



  """

  var infoAttributed: NSAttributedString {
    let infoText = NSMutableAttributedString()

    let headerAttributed =
      NSAttributedString(string: infoHeader, attributes: [NSAttributedString.Key.foregroundColor: Colors.whiteText, NSAttributedString.Key.font: Font.medium(size: 35)])
    let bodyAttributed = NSAttributedString(string: infoBody, attributes: [NSAttributedString.Key.foregroundColor: Colors.whiteText, NSAttributedString.Key.font: Font.medium(size: 18)])
    infoText.append(headerAttributed)
    infoText.append(bodyAttributed)

    return infoText
  }

  var aboutAttributed: NSAttributedString {
    let aboutText = NSMutableAttributedString()

    let headerAttributed =
      NSAttributedString(string: aboutHeader, attributes: [NSAttributedString.Key.foregroundColor: Colors.whiteText, NSAttributedString.Key.font: Font.medium(size: 35)])
    let bodyAttributed = NSAttributedString(string: aboutBody, attributes: [NSAttributedString.Key.foregroundColor: Colors.whiteText, NSAttributedString.Key.font: Font.medium(size: 18)])
    aboutText.append(headerAttributed)
    aboutText.append(bodyAttributed)

    return aboutText
  }
}
