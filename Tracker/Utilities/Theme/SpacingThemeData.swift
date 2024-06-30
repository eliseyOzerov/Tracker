//
//  SpacingThemeData.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation

class SpacingThemeData {
    var s0_5: Double
    var s1: Double
    var s2: Double
    var s3: Double
    var s4: Double
    var s5: Double
    var s6: Double
    var s8: Double
    var s10: Double
    var s12: Double
    var s14: Double
    var s16: Double

    init(
        s0_5: Double = 2,
        s1: Double = 4,
        s2: Double = 8,
        s3: Double = 12,
        s4: Double = 16,
        s5: Double = 20,
        s6: Double = 24,
        s8: Double = 32,
        s10: Double = 40,
        s12: Double = 48,
        s14: Double = 56,
        s16: Double = 64
    ) {
        self.s0_5 = s0_5
        self.s1 = s1
        self.s2 = s2
        self.s3 = s3
        self.s4 = s4
        self.s5 = s5
        self.s6 = s6
        self.s8 = s8
        self.s10 = s10
        self.s12 = s12
        self.s14 = s14
        self.s16 = s16
    }

    init(base: Double) {
        s0_5 = base * 0.5
        s1 = base * 1
        s2 = base * 2
        s3 = base * 3
        s4 = base * 4
        s5 = base * 5
        s6 = base * 6
        s8 = base * 8
        s10 = base * 10
        s12 = base * 12
        s14 = base * 14
        s16 = base * 16
    }
}
