//
//  Lerp.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation

// Linear interpolation between `a` and `b` by fraction `t`
func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
    return a + t * (b - a)
}

// Reverse of linear interpolation: find fraction `t` along the segment from `a` to `b` that produces `v`
func unlerp(_ a: Double, _ b: Double, _ v: Double) -> Double {
    return (v - a) / (b - a)
}

// Bilinear interpolation
func blerp(_ a00: Double, _ a01: Double, _ a10: Double, _ a11: Double, _ tx: Double, _ ty: Double) -> Double {
    let lerpFirst = lerp(a00, a01, tx)
    let lerpSecond = lerp(a10, a11, tx)
    return lerp(lerpFirst, lerpSecond, ty)
}

// Trilinear interpolation
func trilerp(_ a000: Double, _ a010: Double, _ a100: Double, _ a110: Double, _ a001: Double, _ a011: Double, _ a101: Double, _ a111: Double, _ tx: Double, _ ty: Double, _ tz: Double) -> Double {
    let blerpFirst = blerp(a000, a010, a100, a110, tx, ty)
    let blerpSecond = blerp(a001, a011, a101, a111, tx, ty)
    return lerp(blerpFirst, blerpSecond, tz)
}
