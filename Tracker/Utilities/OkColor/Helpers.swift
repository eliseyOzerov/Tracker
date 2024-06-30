//
//  Helpers.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation

// Toe function for tone mapping
func toe(_ x: Double) -> Double {
    let k1 = 0.206
    let k2 = 0.03
    let k3 = (1 + k1) / (1 + k2)
    return 0.5 * (k3 * x - k1 + sqrt((k3 * x - k1) * (k3 * x - k1) + 4 * k2 * k3 * x))
}

// Inverse toe function for tone mapping
func toeInv(_ x: Double) -> Double {
    let k1 = 0.206
    let k2 = 0.03
    let k3 = (1 + k1) / (1 + k2)
    return (x * x + k1 * x) / (k3 * (x + k2))
}

func computeMaxSaturation(_ a: Double, _ b: Double) -> Double {
    // Max saturation will be when one of r, g, or b goes below zero.

    // Select different coefficients depending on which component goes below zero first
    let k0, k1, k2, k3, k4, wl, wm, ws:  Double

    if (-1.88170328 * a - 0.80936493 * b > 1) {
        // Red component
        k0 = 1.19086277;
        k1 = 1.76576728;
        k2 = 0.59662641;
        k3 = 0.75515197;
        k4 = 0.56771245;
        wl = 4.0767416621;
        wm = -3.3077115913;
        ws = 0.2309699292;
    } else if (1.81444104 * a - 1.19445276 * b > 1) {
        // Green component
        k0 = 0.73956515;
        k1 = -0.45954404;
        k2 = 0.08285427;
        k3 = 0.1254107;
        k4 = 0.14503204;
        wl = -1.2684380046;
        wm = 2.6097574011;
        ws = -0.3413193965;
    } else {
        // Blue component
        k0 = 1.35733652;
        k1 = -0.00915799;
        k2 = -1.1513021;
        k3 = -0.50559606;
        k4 = 0.00692167;
        wl = -0.0041960863;
        wm = -0.7034186147;
        ws = 1.707614701;
    }

    // Approximate max saturation using a polynomial:
    var s = k0 + k1 * a + k2 * b + k3 * a * a + k4 * a * b;

    // Do one step Halley's method to get closer
    let kl = 0.3963377774 * a + 0.2158037573 * b;
    let km = -0.1055613458 * a - 0.0638541728 * b;
    let ks = -0.0894841775 * a - 1.291485548 * b;


    let l_ = 1 + s * kl;
    let m_ = 1 + s * km;
    let s_ = 1 + s * ks;

    let l = l_ * l_ * l_;
    let m = m_ * m_ * m_;
    let sCube = s_ * s_ * s_;

    let ldS = 3 * kl * l_ * l_;
    let mdS = 3 * km * m_ * m_;
    let sdS = 3 * ks * s_ * s_;

    let ldS2 = 6 * kl * kl * l_;
    let mdS2 = 6 * km * km * m_;
    let sdS2 = 6 * ks * ks * s_;

    let f = wl * l + wm * m + ws * sCube;
    let f1 = wl * ldS + wm * mdS + ws * sdS;
    let f2 = wl * ldS2 + wm * mdS2 + ws * sdS2;

    s = s - (f * f1) / (f1 * f1 - 0.5 * f * f2);


    return s;
}

func findCusp(a: Double, b: Double) -> [Double] {
    // First, find the maximum saturation (saturation S = C/L)
    let sCusp = computeMaxSaturation(a, b)

    // Convert to linear sRGB to find the first point where at least one of r,g or b >= 1:
    let rgb = convertOklabToLrgb(lab: OkLab(l: 1, a: sCusp * a, b: sCusp * b))
    let lCusp = pow((1 / [rgb.r, rgb.g, rgb.b].max()!), 1 / 3)
    let cCusp = lCusp * sCusp

    return [lCusp, cCusp]
}

func findGamutIntersection(a: Double, b: Double, L1: Double, C1: Double, L0: Double, cusp: [Double]? = nil) -> Double {
    let _cusp = cusp ?? findCusp(a: a, b: b)

    // Find the intersection for upper and lower half separately
    var t: Double
    if (L1 - L0) * _cusp[1] - (_cusp[0] - L0) * C1 <= 0 {
        // Lower half
        t = (_cusp[1] * L0) / (C1 * _cusp[0] + _cusp[1] * (L0 - L1))
    } else {
        // Upper half
        // First intersect with triangle
        t = (_cusp[1] * (L0 - 1)) / (C1 * (_cusp[0] - 1) + _cusp[1] * (L0 - L1))

        // Then one step Halley's method
        let dL = L1 - L0
        let dC = C1

        let kL = 0.3963377774 * a + 0.2158037573 * b
        let kM = -0.1055613458 * a - 0.0638541728 * b
        let kS = -0.0894841775 * a - 1.291485548 * b

        let lDt = dL + dC * kL
        let mDt = dL + dC * kM
        let sDt = dL + dC * kS

        let L = L0 * (1 - t) + t * L1
        let C = t * C1

        let l_ = L + C * kL
        let m_ = L + C * kM
        let s_ = L + C * kS

        let l = l_ * l_ * l_
        let m = m_ * m_ * m_
        let s = s_ * s_ * s_

        let ldt = 3 * lDt * l_ * l_
        let mdt = 3 * mDt * m_ * m_
        let sdt = 3 * sDt * s_ * s_

        let ldt2 = 6 * lDt * lDt * l_
        let mdt2 = 6 * mDt * mDt * m_
        let sdt2 = 6 * sDt * sDt * s_

        let r = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s - 1
        let r1 = 4.0767416621 * ldt - 3.3077115913 * mdt + 0.2309699292 * sdt
        let r2 = 4.0767416621 * ldt2 - 3.3077115913 * mdt2 + 0.2309699292 * sdt2

        let uR = r1 / (r1 * r1 - 0.5 * r * r2)
        var tR = -r * uR

        let g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s - 1
        let g1 = -1.2684380046 * ldt + 2.6097574011 * mdt - 0.3413193965 * sdt
        let g2 = -1.2684380046 * ldt2 + 2.6097574011 * mdt2 - 0.3413193965 * sdt2

        let uG = g1 / (g1 * g1 - 0.5 * g * g2)
        var tG = -g * uG

        let b = -0.0041960863 * l - 0.7034186147 * m + 1.707614701 * s - 1
        let b1 = -0.0041960863 * ldt - 0.7034186147 * mdt + 1.707614701 * sdt
        let b2 = -0.0041960863 * ldt2 - 0.7034186147 * mdt2 + 1.707614701 * sdt2

        let uB = b1 / (b1 * b1 - 0.5 * b * b2)
        var tB = -b * uB

        tR = uR >= 0 ? tR : 10e5
        tG = uG >= 0 ? tG : 10e5
        tB = uB >= 0 ? tB : 10e5

        t += min(tR, tG, tB)
    }

    return t
}

func getStMax(a: Double, b: Double, cusp: [Double]? = nil) -> [Double] {
    let _cusp = cusp ?? findCusp(a: a, b: b)
    let l = _cusp[0]
    let c = _cusp[1]
    return [c / l, c / (1 - l)]
}

func getStMid(a: Double, b: Double) -> [Double] {
    let s = 0.11516993 + 1 / (7.4477897 + 4.1590124 * b + a * (-2.19557347 + 1.75198401 * b + a * (-2.13704948 - 10.02301043 * b + a * (-4.24894561 + 5.38770819 * b + 4.69891013 * a))))
    let t = 0.11239642 + 1 / (1.6132032 - 0.68124379 * b + a * (0.40370612 + 0.90148123 * b + a * (-0.27087943 + 0.6122399 * b + a * (0.00299215 - 0.45399568 * b - 0.14661872 * a))))
    return [s, t]
}

func getCs(L: Double, a: Double, b: Double) -> [Double] {
    let cusp = findCusp(a: a, b: b)

    let cMax = findGamutIntersection(a: a, b: b, L1: L, C1: 1, L0: L, cusp: cusp)
    let stMax = getStMax(a: a, b: b, cusp: cusp)

    let sMid = 0.11516993 + 1 / (7.4477897 + 4.1590124 * b + a * (-2.19557347 + 1.75198401 * b + a * (-2.13704948 - 10.02301043 * b + a * (-4.24894561 + 5.38770819 * b + 4.69891013 * a))))

    let tMid = 0.11239642 + 1 / (1.6132032 - 0.68124379 * b + a * (0.40370612 + 0.90148123 * b + a * (-0.27087943 + 0.6122399 * b + a * (0.00299215 - 0.45399568 * b - 0.14661872 * a))))

    let k = cMax / min(L * stMax[0], (1 - L) * stMax[1])

    let cA = L * sMid
    let cB = (1 - L) * tMid
    let cMid = 0.9 * k * sqrt(sqrt(1 / (1 / (cA * cA * cA * cA) + 1 / (cB * cB * cB * cB))))

    let c0 = sqrt(1 / (1 / (cA * cA) + 1 / (cB * cB)))
    return [c0, cMid, cMax]
}

func normalizeHue(_ hue: Double) -> Double {
    return (hue.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
}

func interpolateHue(start: Double, end: Double, fraction: Double, shortestPath: Bool = true) -> Double {
    var start = normalizeHue(start)
    var end = normalizeHue(end)

    if shortestPath && abs(end - start) > 180 {
        if end > start {
            start += 360
        } else {
            end += 360
        }
    }

    return lerp(start, end, fraction).truncatingRemainder(dividingBy: 360)
}
