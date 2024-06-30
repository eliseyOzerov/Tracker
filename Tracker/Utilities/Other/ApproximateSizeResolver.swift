//
//  ApproximateSizeResolver.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 19. 5. 24.
//

import Foundation

struct ApproximateSizeResolver {
    static func solve(length: Double, dash: Double, space: Double, spacesInside: Bool = true, dashCount: Int? = nil) -> (Double, Double) {
        let x = Double(dashCount ?? Int(ceil(length / (dash + space))));
        let tmp = x * dash + (spacesInside ? x - 1 : x) * space;
        let ratio = length / tmp;
        return (dash * ratio, space * ratio);
    }
}
