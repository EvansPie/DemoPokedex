//
//  Mocks.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation
import DemoPokedexCoreKit

class Mocks {
    
    static func generatePokemonsData(count: Int = 10) throws -> Data {
        let pokemons = (0..<count).map({ Mocks.generatePokemon(id: $0) })
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let mockData = try encoder.encode(pokemons)
            return mockData
        } catch {
            throw error
        }
    }
    
    static func generatePokemonData(id: Int) throws -> Data {
        let pokemon = Pokemon(
            id: id,
            name: "Pokemon \(id)",
            types: [
                PokemonType.allCases.randomElement()!
            ],
            abilities: [
                String.random(length: 8),
                String.random(length: 8)
            ],
            hitpoints: Int.random(in: 1..<100),
            evolutions: [
                String.random(length: 8),
                String.random(length: 8)
            ],
            region: "Region \(Int.random(in: 1...5))",
            road: "Road \(Int.random(in: 1...20))",
            imageUrl: URL(string: "https://static8.depositphotos.com/1012223/980/i/450/depositphotos_9803930-stock-photo-demo-cubes.jpg")!)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let mockData = try encoder.encode(pokemon)
            return mockData
        } catch {
            throw error
        }
    }
    
    static func generatePokemon(id: Int) -> Pokemon {
        return Pokemon(
            id: id,
            name: "Pokemon \(id)",
            types: [
                PokemonType.allCases.randomElement()!
            ],
            abilities: [
                String.random(length: 8),
                String.random(length: 8)
            ],
            hitpoints: Int.random(in: 1..<100),
            evolutions: [
                String.random(length: 8),
                String.random(length: 8)
            ],
            region: "Region \(Int.random(in: 1...5))",
            road: "Road \(Int.random(in: 1...20))",
            imageUrl: URL(string: "https://static8.depositphotos.com/1012223/980/i/450/depositphotos_9803930-stock-photo-demo-cubes.jpg")!)
    }
    
    static func getPokemonsDataFromLocalJSON() throws -> Data {
        return try FileManager.getBundledFileData(of: "pokemons.json")
    }
}
