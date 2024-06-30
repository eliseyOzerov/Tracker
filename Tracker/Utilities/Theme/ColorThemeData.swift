//
//  ColorThemeData.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation
import SwiftUI

struct ColorTheme {
    let primary: Color
    let onPrimary: Color
    let primarySurface: Color
    let onPrimarySurface: Color
    let background: Color
    let surface: Color
    let secondarySurface: Color
    let tertiarySurface: Color
    let primaryText: Color
    let secondaryText: Color
    let shadow: Color
}

class ColorThemeData {
    var red: HueToken!
    var orange: HueToken!
    var yellow: HueToken!
    var lime: HueToken!
    var green: HueToken!
    var teal: HueToken!
    var cyan: HueToken!
    var sky: HueToken!
    var blue: HueToken!
    var purple: HueToken!
    var magenta: HueToken!
    var pink: HueToken!

    var hues: [HueToken] {
        return [red, orange, yellow, lime, green, teal, cyan, sky, blue, purple, magenta, pink]
    }

    var hueColors: [OkHsv]!

    private var _brand: HueToken!
        var brand: HueToken {
        return _brand
    }

    init(color: Color) {
        let okHsv = OkHsv.fromColor(color)
        let hues = okHsv.hueCircle()
        hueColors = hues
        _brand = HueToken(from: okHsv)
        red = HueToken(from: OkHsv.colorForHue(.red, colors: hues))
        orange = HueToken(from: OkHsv.colorForHue(.orange, colors: hues))
        yellow = HueToken(from: OkHsv.colorForHue(.yellow, colors: hues))
        lime = HueToken(from: OkHsv.colorForHue(.lime, colors: hues))
        green = HueToken(from: OkHsv.colorForHue(.green, colors: hues))
        teal = HueToken(from: OkHsv.colorForHue(.teal, colors: hues))
        cyan = HueToken(from: OkHsv.colorForHue(.cyan, colors: hues))
        sky = HueToken(from: OkHsv.colorForHue(.sky, colors: hues))
        blue = HueToken(from: OkHsv.colorForHue(.blue, colors: hues))
        purple = HueToken(from: OkHsv.colorForHue(.purple, colors: hues))
        magenta = HueToken(from: OkHsv.colorForHue(.magenta, colors: hues))
        pink = HueToken(from: OkHsv.colorForHue(.pink, colors: hues))
    }
}

struct HueToken {
  let vibrant: Scale
  let normal: Scale
  let muted: Scale
  let grayscale: Scale
  let main: Scale
  let analogous: Scale
  
  var scales: [Scale] {
    return [main, normal, vibrant, muted, grayscale]
  }
  
  init(vibrant: Scale, normal: Scale, muted: Scale, grayscale: Scale, main: Scale, analogous: Scale) {
    self.vibrant = vibrant
    self.normal = normal
    self.muted = muted
    self.grayscale = grayscale
    self.main = main
    self.analogous = analogous
  }
  
  init(from hsv: OkHsv) {
    let main = Scale(start: hsv.withValue(100).withSaturation(10), end: hsv.withValue(30).withSaturation(100), cusp: hsv)
    let vibrant = Scale(start: hsv.withValue(100).withSaturation(10), end: hsv.withValue(30).withSaturation(100), cusp: hsv.withSaturation(100).withValue(100))
    let normal = Scale(start: hsv.withValue(100).withSaturation(10), end: hsv.withValue(30).withSaturation(100), cusp: hsv.withSaturation(85).withValue(95))
    let muted = Scale(start: hsv.withValue(100).withSaturation(10), end: hsv.withValue(30).withSaturation(100), cusp: hsv.withSaturation(50).withValue(70))
    let grayscale = Scale(start: hsv.withValue(100).withSaturation(0.01), end: hsv.withValue(0).withSaturation(0.01), cusp: hsv.withValue(70).withSaturation(0.01))
    let analogous = Scale(start: hsv.rotateAbsolute(-30), end: hsv.rotateAbsolute(30), cusp: hsv)
    
    self.init(vibrant: vibrant, normal: normal, muted: muted, grayscale: grayscale, main: main, analogous: analogous)
  }
}

struct Scale {
    var v950: Color
    var v900: Color
    var v800: Color
    var v700: Color
    var v600: Color
    var v500: Color
    var v400: Color
    var v300: Color
    var v200: Color
    var v100: Color
    var v50: Color

    var colors: [Color] {
        return [v950, v900, v800, v700, v600, v500, v400, v300, v200, v100, v50]
    }

    init(v950: Color, v900: Color, v800: Color, v700: Color, v600: Color, v500: Color, v400: Color, v300: Color, v200: Color, v100: Color, v50: Color) {
        self.v950 = v950
        self.v900 = v900
        self.v800 = v800
        self.v700 = v700
        self.v600 = v600
        self.v500 = v500
        self.v400 = v400
        self.v300 = v300
        self.v200 = v200
        self.v100 = v100
        self.v50 = v50
    }

    // Constructs a scale, with the first color being the brightest and the last being the darkest
    init(colors: [Color]) {
        self.init(v950: colors[10], v900: colors[9], v800: colors[8], v700: colors[7], v600: colors[6], v500: colors[5], v400: colors[4], v300: colors[3], v200: colors[2], v100: colors[1], v50: colors[0])
    }
  
    /// Create a scale from parameters
    init(start: OkHsv, end: OkHsv, cusp: OkHsv?) {
        var scale: [Color] = []
        if let cusp = cusp {
            scale.append(start.toColor())
            for i in 1...5 {
                scale.append(interpolateOkHsv(start: start, end: cusp, fraction: CGFloat(i) / 5).toColor())
            }
            scale.append(cusp.toColor())
            for i in 1...5 {
                scale.append(interpolateOkHsv(start: cusp, end: end, fraction: CGFloat(i) / 5).toColor())
            }
            scale.append(end.toColor())
        } else {
            for i in 0...10 {
                scale.append(interpolateOkHsv(start: start, end: end, fraction: CGFloat(i) / 10).toColor())
            }
        }

        self.init(colors: scale)
    }
}
