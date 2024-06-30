//
//  FontExtension.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 17. 5. 24.
//

import Foundation
import SwiftUI

struct TypeScale {
  static let minorSecond = 1.067
  static let majorSecond = 1.125
  static let minorThird = 1.2
  static let majorThird = 1.25
  static let perfectFourth = 1.333
  static let augmentedFourth = 1.414
  static let perfectFifth = 1.5
  static let goldenRatio = 1.618
}

extension Font {
    static let base = Font.system(size: 16, design: .rounded)
}
