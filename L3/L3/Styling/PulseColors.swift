//
//  PulseColors.swift
//  L3
//
//  Created by Milton Leung on 2019-02-23.
//  Copyright © 2019 ms. All rights reserved.
//

import Foundation
import UIKit

internal typealias PulseColor = (dotBackground: CGColor, dotBorder: CGColor, pulseBackground: CGColor, pulseBorder: CGColor)

final class PulseColors {
  static let red: PulseColor = (#colorLiteral(red: 0.862745098, green: 0.2, blue: 0.3294117647, alpha: 1), #colorLiteral(red: 0.7803921569, green: 0.2509803922, blue: 0.2666666667, alpha: 0.53), #colorLiteral(red: 0.7411764706, green: 0.3058823529, blue: 0.3176470588, alpha: 0.6998448202), #colorLiteral(red: 0.7294117647, green: 0.3176470588, blue: 0.3254901961, alpha: 0.7))
  static let teal: PulseColor = (#colorLiteral(red: 0.2, green: 0.862745098, blue: 0.7215686275, alpha: 1), #colorLiteral(red: 0.1725490196, green: 0.6274509804, blue: 0.5294117647, alpha: 0.53), #colorLiteral(red: 0.3254901961, green: 0.8509803922, blue: 0.7411764706, alpha: 0.6998448202), #colorLiteral(red: 0.1176470588, green: 0.5411764706, blue: 0.4509803922, alpha: 0.699734589))
  static let lightBlue: PulseColor = (#colorLiteral(red: 0.2980392157, green: 0.7176470588, blue: 0.7607843137, alpha: 1), #colorLiteral(red: 0.3450980392, green: 0.7921568627, blue: 0.8352941176, alpha: 0.53), #colorLiteral(red: 0.3411764706, green: 0.768627451, blue: 0.8117647059, alpha: 0.6998448202), #colorLiteral(red: 0.2549019608, green: 0.6, blue: 0.6352941176, alpha: 0.7))
  static let blue: PulseColor = (#colorLiteral(red: 0.2588235294, green: 0.4745098039, blue: 0.7882352941, alpha: 1), #colorLiteral(red: 0.168627451, green: 0.4392156863, blue: 0.8392156863, alpha: 0.53), #colorLiteral(red: 0.262745098, green: 0.4588235294, blue: 0.7490196078, alpha: 0.6998448202), #colorLiteral(red: 0.262745098, green: 0.4588235294, blue: 0.7490196078, alpha: 0.699734589))
  static let ultramarine: PulseColor = (#colorLiteral(red: 0.2431372549, green: 0.2745098039, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.2941176471, green: 0.3254901961, blue: 0.8666666667, alpha: 0.53), #colorLiteral(red: 0.262745098, green: 0.2901960784, blue: 0.7490196078, alpha: 0.6998448202), #colorLiteral(red: 0.2745098039, green: 0.3058823529, blue: 0.8039215686, alpha: 0.699734589))
  static let green: PulseColor = (#colorLiteral(red: 0.4509803922, green: 0.768627451, blue: 0.3725490196, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.7843137255, blue: 0.3411764706, alpha: 0.53), #colorLiteral(red: 0.4509803922, green: 0.768627451, blue: 0.3725490196, alpha: 0.6998448202), #colorLiteral(red: 0.3058823529, green: 0.7254901961, blue: 0.2039215686, alpha: 0.699734589))
  static let orange: PulseColor = (#colorLiteral(red: 0.8470588235, green: 0.462745098, blue: 0.1803921569, alpha: 1), #colorLiteral(red: 0.8901960784, green: 0.4588235294, blue: 0.1411764706, alpha: 0.53), #colorLiteral(red: 0.8431372549, green: 0.4470588235, blue: 0.1568627451, alpha: 0.6998448202), #colorLiteral(red: 0.7764705882, green: 0.4, blue: 0.1215686275, alpha: 0.699734589))
  static let yellow: PulseColor = (#colorLiteral(red: 0.9803921569, green: 0.7607843137, blue: 0.3450980392, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.7333333333, blue: 0.3019607843, alpha: 0.53), #colorLiteral(red: 1, green: 0.7960784314, blue: 0.4156862745, alpha: 0.6998448202), #colorLiteral(red: 0.7843137255, green: 0.5960784314, blue: 0.2392156863, alpha: 0.699734589))
  static let purple: PulseColor = (#colorLiteral(red: 0.6901960784, green: 0.3490196078, blue: 0.8549019608, alpha: 1), #colorLiteral(red: 0.5921568627, green: 0.2941176471, blue: 0.737254902, alpha: 0.53), #colorLiteral(red: 0.6823529412, green: 0.3254901961, blue: 0.8509803922, alpha: 0.6998448202), #colorLiteral(red: 0.4823529412, green: 0.2352941176, blue: 0.6, alpha: 0.699734589))
  static let magenta: PulseColor = (#colorLiteral(red: 0.6666666667, green: 0.2509803922, blue: 0.6509803922, alpha: 1), #colorLiteral(red: 0.7607843137, green: 0.2745098039, blue: 0.7411764706, alpha: 0.53), #colorLiteral(red: 0.7607843137, green: 0.2745098039, blue: 0.7411764706, alpha: 0.6998448202), #colorLiteral(red: 0.5882352941, green: 0.2196078431, blue: 0.5764705882, alpha: 0.699734589))

  private var currentColor = 0

  private var colors = [
    ("red", PulseColors.red),
    ("teal", PulseColors.teal),
    ("lightBlue", PulseColors.lightBlue),
    ("blue", PulseColors.blue),
    ("ultramarine", PulseColors.ultramarine),
    ("green", PulseColors.green),
    ("orange", PulseColors.orange),
    ("yellow", PulseColors.yellow),
    ("purple", PulseColors.purple),
    ("magenta", PulseColors.magenta)
  ]

  func getNextColor(reset: Bool = false) -> (String, PulseColor) {
    if reset {
      currentColor = 0
      return colors[currentColor]
    } else {
      let nextColor = colors[currentColor]
      currentColor = (currentColor + 1) % colors.count
      return nextColor
    }
  }
}
