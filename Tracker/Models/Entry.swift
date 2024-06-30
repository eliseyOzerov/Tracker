//
//  Entry.swift
//  Entry
//
//  Created by Elisey Ozerov on 19. 6. 24.
//

import Foundation
import SwiftData

@Model
class Entry<T: PersistentModel>: Identifiable {
    let id: UUID
    let timestamp: Date
    let value: T
    
    init(id: UUID = UUID(), timestamp: Date, value: T) {
        self.id = id
        self.timestamp = timestamp
        self.value = value
    }
}
