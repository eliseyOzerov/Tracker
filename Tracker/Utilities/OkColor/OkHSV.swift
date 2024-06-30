//
//  OkHSV.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation

func interpolateOkHsv(start: OkHsv, end: OkHsv, fraction: Double, shortestPath: Bool = true) -> OkHsv {
    // Ensure fraction is within [0, 1]
    let clampedFraction = fraction.clamp(0, 1)

    // Use the lerp function for s and v
    let s = lerp(start.s, end.s, clampedFraction)
    let v = lerp(start.v, end.v, clampedFraction)

    // Use the hueInterpolation function for h
    let h = interpolateHue(start: start.h, end: end.h, fraction: clampedFraction, shortestPath: shortestPath)

    return OkHsv(h: h, s: s, v: v)
}

func okhsvToOklab(okHsv: OkHsv) -> OkLab {
    let h = okHsv.h
    let s = okHsv.s
    let v = okHsv.v

    let a = cos((h / 180) * Double.pi)
    let b = sin((h / 180) * Double.pi)

    let stMax = getStMax(a: a, b: b)
    let sMax = stMax[0]
    let t = stMax[1]
    let s0 = 0.5
    let k = 1 - s0 / sMax
    let lV = 1 - (s * s0) / (s0 + t - t * k * s)
    let cV = (s * t * s0) / (s0 + t - t * k * s)

    let lVt = toeInv(lV)
    let cVt = (cV * lVt) / lV
    let rgbScale = convertOklabToLrgb(lab: OkLab(l: lVt, a: a * cVt, b: b * cVt))
    let scaleL = pow((1 / [rgbScale.r, rgbScale.g, rgbScale.b].max()!), 1 / 3.0)

    let lNew = toeInv(v * lV)
    let c = (cV * lNew) / lV

    return OkLab(
        l: lNew * scaleL,
        a: c * a * scaleL,
        b: c * b * scaleL
    )
}

func convertOklabToOkhsv(lab: OkLab) -> OkHsv {
    var l = lab.l
    let a = lab.a
    let b = lab.b

    var c = sqrt(a * a + b * b)

    let a_ = c != 0 ? a / c : 1
    let b_ = c != 0 ? b / c : 1

    let stMax = getStMax(a: a_, b: b_)
    let sMax = stMax[0]
    let T = stMax[1]
    let s0 = 0.5
    let k = 1 - s0 / sMax

    let t = T / (c + l * T)
    let Lv = t * l
    let Cv = t * c

    let Lvt = toeInv(Lv)
    let Cvt = (Cv * Lvt) / Lv

    let rgbScale = convertOklabToLrgb(lab: OkLab(l: Lvt, a: a_ * Cvt, b: b_ * Cvt))
    let scaleL = pow((1 / [rgbScale.r, rgbScale.g, rgbScale.b].max()!), 1 / 3.0)

    l = l / scaleL
    let toeL = toe(l)
    c = ((c / scaleL) * toeL) / l
    l = toeL

    let s = c != 0 ? ((s0 + T) * Cv) / (T * s0 + T * k * Cv) : 0
    let v = l != 0 ? l / Lv : 0
    var h = 0.0
    if s != 0 {
        h = normalizeHue((atan2(b, a) * 180) / Double.pi)
    }

    return OkHsv(h: h, s: s, v: v, alpha: lab.alpha)
}
