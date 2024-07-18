//
//  StringExtension.swift
//  Tracker
//
//  Created by Elisey Ozerov on 15. 7. 24.
//

import Foundation

extension String {
    func camelCaseToSentenceCase() -> String? {
        // Insert space before each uppercase letter except the first one
        let pattern = "([a-z])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        let range = NSRange(location: 0, length: self.count)
        let modifiedString = regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1 $2") ?? self
        
        // Convert the first character to uppercase and the rest to lowercase
        guard let firstChar = modifiedString.first else { return nil }
        let sentenceCaseString = firstChar.uppercased() + modifiedString.dropFirst().lowercased()
        
        return sentenceCaseString
    }
}
