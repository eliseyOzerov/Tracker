//
//  NumberExtension.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation

extension Comparable {
    func clamp(_ lower: Self, _ upper: Self) -> Self {
        return min(max(lower, self), upper)
    }
}

extension Double {
    func format(maxDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxDigits
        return formatter.string(from: self as NSNumber)!
    }
}
