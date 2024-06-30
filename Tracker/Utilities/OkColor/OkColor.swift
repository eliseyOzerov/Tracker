//
//  OkColor.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation
import SwiftUI

enum Hue: String {
  case red
  case orange
  case yellow
  case lime
  case green
  case teal
  case cyan
  case sky
  case blue
  case purple
  case magenta
  case pink
}

/// Hue must be between 0 and 360, saturation, value and alpha between 0 and 1
class OkHsv {
    let h: Double
    let s: Double
    let v: Double
    let alpha: Double

    init(h: Double, s: Double, v: Double, alpha: Double = 1) {
        self.h = h.truncatingRemainder(dividingBy: 360)
        self.s = (s * 100).rounded(.down) / 100 > 1 ? s / 100 : s
        self.v = (v * 100).rounded(.down) / 100 > 1 ? v / 100 : v
        self.alpha = alpha > 1 ? alpha / 100 : alpha
    }

    var description: String {
        return "OkHsv(h: \(h), s: \(s), v: \(v), alpha: \(alpha))"
    }

    static let hues: [Hue: Int] = [
        .pink: 0,
        .red: 30,
        .orange: 60,
        .yellow: 90,
        .lime: 120,
        .green: 140,
        .teal: 160,
        .cyan: 190,
        .sky: 230,
        .blue: 270,
        .purple: 300,
        .magenta: 330
    ]

    static func colorForHue(_ hue: Hue, colors: [OkHsv]) -> OkHsv {
        var highestDistance = Double.infinity
        var result: OkHsv!
        var hueVal = hues[hue]!
        if hue == .pink {
          hueVal = 360
        }
        for color in colors {
          let distance = abs(color.h - Double(hueVal))
          if distance < highestDistance {
            highestDistance = distance
            result = color
          }
        }
        return result
    }

    static func hueForColor(color: OkHsv) -> Hue {
        var highestDistance: Double = Double.infinity
        var result: Hue = .red
        for hue in hues {
          let distance = abs(color.h - Double(hue.value))
          if distance < highestDistance {
            highestDistance = distance
            result = hue.key
          }
        }
        return result
    }

    func toColor() -> Color {
        return toOklab().toLrgb().toRgb().toColor()
      }

    static func fromColor(_ color: Color) -> OkHsv {
        let rgb = Rgb.fromColor(color)
        let lrgb = rgb.toLrgb()
        let oklab = lrgb.toOklab()
        let res = oklab.toOkhsv()
        return res
    }

    func toOklab() -> OkLab {
        return okhsvToOklab(okHsv: self)
    }

    func withHue(_ hue: Double) -> OkHsv {
        return OkHsv(h: hue, s: s, v: v, alpha: alpha)
    }

    func withSaturation(_ saturation: Double) -> OkHsv {
        return OkHsv(h: h, s: saturation, v: v, alpha: alpha)
    }

    func withValue(_ value: Double) -> OkHsv {
        return OkHsv(h: h, s: s, v: value, alpha: alpha)
    }

    func withAlpha(_ alpha: Double) -> OkHsv {
        return OkHsv(h: h, s: s, v: v, alpha: alpha)
    }

    func darker(_ percentage: Double) -> OkHsv {
        return withValue(v * (1 - percentage))
    }

    func lighter(_ percentage: Double) -> OkHsv {
        return withValue(v * (1 + percentage))
    }

    func duller(_ percentage: Double) -> OkHsv {
        return withSaturation(s * (1 - percentage))
    }

    func richer(_ percentage: Double) -> OkHsv {
        return withSaturation(s * (1 + percentage))
    }

    func rotateRatio(_ percentage: Double) -> OkHsv {
        return withHue((h + percentage * 360).truncatingRemainder(dividingBy: 360))
    }

    func rotateAbsolute(_ angle: Double) -> OkHsv {
        return withHue((h + angle).truncatingRemainder(dividingBy: 360))
    }

    func rotateTo(_ angle: Double) -> OkHsv {
        return withHue(angle)
    }

    func hueCircle(_ count: Int = 12) -> [OkHsv] {
        let step = 360.0 / Double(count)
        return (0..<count).map { index in
          rotateAbsolute(step * Double(index))
        }
    }
}

struct OkLab {
  let l: Double
  let a: Double
  let b: Double
  let alpha: Double

  init(l: Double, a: Double, b: Double, alpha: Double = 1) {
    self.l = l
    self.a = a
    self.b = b
    self.alpha = alpha
  }

  func toOkhsv() -> OkHsv {
      return convertOklabToOkhsv(lab: self)
  }

  func toLrgb() -> Lrgb {
      return convertOklabToLrgb(lab: self)
  }

  var description: String {
    return "OkLab(l: \(l), a: \(a), b: \(b), alpha: \(alpha))"
  }
}

class Lrgb {
    let r: Double
    let g: Double
    let b: Double
    let alpha: Double

    init(r: Double, g: Double, b: Double, alpha: Double = 1) {
        self.r = r
        self.g = g
        self.b = b
        self.alpha = alpha
    }

    func toRgb() -> Rgb {
        return convertLrgbToRgb(self)
    }

    func toOklab() -> OkLab {
        return convertLrgbToOklab(lrgb: self)
    }
    
    var description: String {
        return "Lrgb(r: \(r), g: \(g), b: \(b), alpha: \(alpha))"
    }
}

struct Rgb {
    let r: Int
    let g: Int
    let b: Int
    let alpha: Double

    init(r: Int, g: Int, b: Int, alpha: Double = 1) {
        self.r = r
        self.g = g
        self.b = b
        self.alpha = alpha
    }

    func toLrgb() -> Lrgb {
        return convertRgbToLrgb(self)
    }

    static func fromColor(_ color: Color) -> Rgb {
        if let components = color.components {
          return Rgb(r: Int(components.red * 255), g: Int(components.green * 255), b: Int(components.blue * 255), alpha: Double(components.alpha))
        }
        return Rgb(r: 0, g: 0, b: 0)
    }

    func toColor() -> Color {
        return Color(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255).opacity(alpha)
    }

    var description: String {
        return "RGB(r: \(r), g: \(g), b: \(b), alpha: \(alpha))"
    }
}
