//
//  StringExtension.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation

extension String {
    func removingSpecialCharacters() -> String {
        let pattern = "[^a-zA-Z0-9]"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        } catch {
            print("Error removing special characters: \(error)")
            return self
        }
    }
}
