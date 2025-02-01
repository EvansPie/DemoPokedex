//
//  StringExtensions.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

public extension String {
    
    static func random(length: Int, characters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
        guard length > 0 else { return "" }
        
        return String((0..<length).compactMap { _ in
            characters.randomElement()
        })
    }
    
    func firstLetterOfEachWordCapitalized() -> String {
        return self.split(separator: " ").map {
            $0.prefix(1).uppercased() + $0.dropFirst().lowercased()
        }.joined(separator: " ")
    }
}
