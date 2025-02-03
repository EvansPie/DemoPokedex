//
//  SortOption.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

enum SortOption: String, CaseIterable {
    
    case alphabetically = "alphabetically"
    case hitpointsAscending = "hpAscending"
    case hitpointsDescending = "hpDescending"
    
    var id: String {
        return rawValue
    }
        
    var position: Int {
        switch self {
        case .alphabetically:
            return 0
        case .hitpointsAscending:
            return 1
        case .hitpointsDescending:
            return 2
        }
    }
    
    var userFriendlyValue: String {
        switch self {
        case .alphabetically:
            return "Alphabetically"
        case .hitpointsAscending:
            return "HP ↗"
        case .hitpointsDescending:
            return "HP ↘"
        }
    }
}
