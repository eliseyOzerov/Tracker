//
//  JsonConverter.swift
//  Tracker
//
//  Created by Elisey Ozerov on 19. 6. 24.
//

import Foundation

// Helper function to serialize properties dictionary to JSON
func toJson(_ props: [String: Any]) -> String {
    if let jsonData = try? JSONSerialization.data(withJSONObject: props, options: []) {
        return String(data: jsonData, encoding: .utf8) ?? "{}"
    }
    return "{}"
}

// Helper function to deserialize JSON string back to dictionary
func fromJson(_ props: String) -> [String: Any]? {
    if let data = props.data(using: .utf8) {
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
    return nil
}
