//
//  PokemonType.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation
import DemoPokedexCoreKit
import SwiftUI

enum PokemonType: String, CaseIterable {
    
    case dragon = "dragon"
    case electric = "electric"
    case fighting = "fighting"
    case fire = "fire"
    case flying = "flying"
    case ghost = "ghost"
    case grass = "grass"
    case ground = "ground"
    case ice = "ice"
    case normal = "normal"
    case poison = "poison"
    case psychic = "psychic"
    case rock = "rock"
    case steel = "steel"
    case water = "water"
    
    var userFriendlyValue: String {
        return rawValue.firstLetterOfEachWordCapitalized()
    }
    
    /// ✨ In order to remove the SwiftUI dependency, we could return the hex string of the color
    var representingColor: Color {
        switch self {
        case .dragon:
            return Color.purple
        case .electric:
            return Color.yellow
        case .fighting:
            return Color.red
        case .fire:
            return Color.orange
        case .flying:
            return Color.blue.opacity(0.5)
        case .ghost:
            return Color.purple
        case .grass:
            return Color.green
        case .ground:
            return Color.brown
        case .ice:
            return Color.cyan
        case .normal:
            return Color.gray
        case .poison:
            return Color.purple
        case .psychic:
            return Color.pink
        case .rock:
            return Color.yellow.opacity(0.8)
        case .steel:
            return Color.gray.opacity(0.7)
        case .water:
            return Color.blue
        }
    }
}
