//
//  ColorExtension.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 17. 5. 24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        // Convert the Color to UIColor
        let uiColor = UIColor(self)
        
        // Variables to store the components
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Try to get the RGB components
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        } else {
            // Return nil if unable to extract components
            return nil
        }
    }
}

extension Color {
    func darker(_ percentage: Double) -> Color {
        assert(percentage >= 0 && percentage <= 1, "Value must be between 0 and 1")
        let red = self.components!.red * (1 - percentage)
        let green = self.components!.green * (1 - percentage)
        let blue = self.components!.blue * (1 - percentage)
        return Color(red: red, green: green, blue: blue).opacity(self.components!.alpha)
    }

    func lighter(_ percentage: Double) -> Color {
        assert(percentage >= 0 && percentage <= 1, "Value must be between 0 and 1")
        let red = self.components!.red + ((1 - self.self.components!.red) * percentage)
        let green = self.components!.green + ((1 - self.components!.green) * percentage)
        let blue = self.components!.blue + ((1 - self.components!.blue) * percentage)
        return Color(red: red, green: green, blue: blue).opacity(self.components!.alpha)
    }

    func duller(_ percentage: Double) -> Color {
        assert(percentage >= 0 && percentage <= 1, "Value must be between 0 and 1")
        let hsv = OkHsv.fromColor(self)
        let saturation = hsv.s * (1 - percentage)
        return Color(hue: hsv.h, saturation: saturation, brightness: hsv.v).opacity(self.components!.alpha)
    }

    func richer(_ percentage: Double) -> Color {
        assert(percentage >= 0 && percentage <= 1, "Value must be between 0 and 1")
        let hsv = OkHsv.fromColor(self)
        let saturation = hsv.s * (1 + percentage)
        return Color(hue: hsv.h, saturation: saturation, brightness: hsv.v).opacity(self.components!.alpha)
    }
}

// MARK: - Custom dynamic initializers

extension UIColor {
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
     ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            default:
                return lightModeColor()
            }
        }
    }
}

extension Color {
    init(
        light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color
    ) {
        self.init(UIColor(
            light: UIColor(lightModeColor()),
            dark: UIColor(darkModeColor())
        ))
    }
}
