//
//  Item.swift
//  Budget
//
//  Created by Elisey Ozerov on 12. 6. 24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
