//
//  RGB.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation

// Helper function to handle RGB color conversion
func fnRgb(_ c: Double) -> Double {
    let absC = abs(c)
    if absC > 0.0031308 {
        return (c.sign == 0.sign ? 1.0 : Double(c.sign.rawValue)) * (1.055 * pow(absC, 1 / 2.4) - 0.055)
    }
    return c * 12.92
}

// Helper function to handle linear RGB color conversion
func fnLrgb(_ c: Double) -> Double {
    let absC = abs(c)
    if absC <= 0.04045 {
        return c / 12.92
    }
    return (c.sign == 0.sign ? 1.0 : Double(c.sign.rawValue)) * pow((absC + 0.055) / 1.055, 2.4)
}

// Convert linear RGB to RGB
func convertLrgbToRgb(_ lrgb: Lrgb) -> Rgb {
    return Rgb(
        r: Int(fnRgb(lrgb.r) * 255),
        g: Int(fnRgb(lrgb.g) * 255),
        b: Int(fnRgb(lrgb.b) * 255),
        alpha: lrgb.alpha
    )
}

// Convert RGB to linear RGB
func convertRgbToLrgb(_ rgb: Rgb) -> Lrgb {
    return Lrgb(
        r: fnLrgb(Double(rgb.r) / 255),
        g: fnLrgb(Double(rgb.g) / 255),
        b: fnLrgb(Double(rgb.b) / 255),
        alpha: rgb.alpha
    )
}
