//
//  UIColor+Utils.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 02.09.2021.
//

import UIKit

extension UIColor {
  static func random () -> UIColor {
    return UIColor(red: CGFloat.random(in: 0...1),
                   green: CGFloat.random(in: 0...1),
                   blue: CGFloat.random(in: 0...1),
                   alpha: 1.0)
  }
}
