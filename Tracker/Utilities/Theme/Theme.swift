//
//  Theme.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 17. 5. 24.
//

import Foundation
import SwiftUI

class Theme {
    static let spacing = SpacingThemeData(base: 4)
    static let radius = SpacingThemeData(base: 5)
    static let border = SpacingThemeData(base: 0.5)
    
    static let color = ColorTheme(
        primary: Color(light: colorData.brand.main.v500, dark: colorData.brand.main.v600),
        onPrimary: Color(light: colorData.brand.grayscale.v50, dark: colorData.brand.grayscale.v50),
        primarySurface: Color(light: colorData.brand.main.v50, dark: colorData.brand.muted.v800),
        onPrimarySurface: Color(light: colorData.brand.main.v500, dark: colorData.brand.main.v100),
        background: Color(light: colorData.brand.grayscale.v50, dark: colorData.brand.grayscale.v950),
        surface: Color(light: colorData.brand.grayscale.v50, dark: colorData.brand.grayscale.v50),
        secondarySurface: Color(light: colorData.brand.grayscale.v100, dark: colorData.brand.grayscale.v900),
        tertiarySurface: Color(light: .white, dark: colorData.brand.grayscale.v950.lighter(0.05)),
        primaryText: Color(light: colorData.brand.grayscale.v900, dark: colorData.brand.grayscale.v50),
        secondaryText: Color(light: colorData.brand.grayscale.v600, dark: colorData.brand.grayscale.v300),
        shadow: Color(light: colorData.brand.grayscale.v200, dark: colorData.brand.grayscale.v950.darker(0.5))
    )
    
    static let colorData = ColorThemeData(color: Color(hex: 0xff7000FF))
}


