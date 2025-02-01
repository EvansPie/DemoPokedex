//
//  ArrayExtensions.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

public extension Array where Element: Hashable {
    
    var unique: [Element] {
        return unique(preserveOrder: true)
    }
    
    func unique(preserveOrder: Bool) -> [Element] {
        if preserveOrder {
            var seen = Set<Element>()
            /// **insert()** returns a tuple with the value, and an **inserted** flag whether the insertion was successful,
            /// which can be used in the filter.
            return self.filter { seen.insert($0).inserted }
        } else {
            return Array(Set(self))
        }
    }
}
