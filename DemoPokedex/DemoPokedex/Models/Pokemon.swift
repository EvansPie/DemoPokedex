//
//  Pokemon.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation
import DemoPokedexCoreKit

struct Pokemon: Codable, Sendable {
    
    let id: Int
    let name: String
    let types: [PokemonType]  // Changed from `type` to `types` to store multiple enum cases
    let abilities: [String]
    let hitpoints: Int
    let evolutions: [String]
    let region: String
    let road: String?
    let imageUrl: URL
    
    /// Recreate JSON's location from `region`, and `road`
    var location: String {
        var locationString = self.region
        if let road, road.isEmpty.not {
            locationString += ", \(road)"
        }
        return locationString
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "pokemon"
        case types = "type"  // Use `type` for the mapped key
        case abilities
        case hitpoints
        case evolutions
        case location
        case imageUrl = "image_url"
    }
    
    /// This initializer will only be called to create test Pokemons, and convert them to `Data`, so we can mock API calls.
    init(id: Int, name: String, types: [PokemonType], abilities: [String], hitpoints: Int, evolutions: [String], region: String, road: String?, imageUrl: URL) {
        self.id = id
        self.name = name
        self.types = types
        self.abilities = abilities
        self.hitpoints = hitpoints
        self.evolutions = evolutions
        self.region = region
        self.road = road
        self.imageUrl = imageUrl
    }
    
    /// Custom initializer to handle custom conversions
    ///  - `type` string into array PokemonType enum
    ///  - `location` string into `region`, and `road`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let typeString = try container.decode(String.self, forKey: .types)
        // Handle the type field, which could be a single value or a slash-separated list. Make sure the value
        // is lowercased (as are the enum cases) to avoid mistakes.
        types = typeString.split(separator: "/").compactMap { PokemonType(rawValue: String($0.lowercased())) }
        
        abilities = try container.decode([String].self, forKey: .abilities)
        hitpoints = try container.decode(Int.self, forKey: .hitpoints)
        evolutions = try container.decode([String].self, forKey: .evolutions)
        let locationString = try container.decode(String.self, forKey: .location)
        let locationComponents = locationString.split(separator: ",").compactMap { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
        
        if locationComponents.isEmpty {
            fatalError()
        }
        
        self.region = locationComponents.first!
        
        if locationComponents.count > 1 {
            self.road = locationComponents[1]
        } else {
            self.road = nil
        }
        
        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
    }
    
    /// Encoder is only needed to create `data` from `Pokemon` objects in order to mock. Other than that, the class could just be a `Decodable` class
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        let typeString = types.map { $0.rawValue.firstLetterOfEachWordCapitalized() }.joined(separator: "/")
        try container.encode(typeString, forKey: .types)
        try container.encode(abilities, forKey: .abilities)
        try container.encode(hitpoints, forKey: .hitpoints)
        try container.encode(evolutions, forKey: .evolutions)
        try container.encode(location, forKey: .location)
        try container.encode(imageUrl, forKey: .imageUrl)
    }
}

extension Pokemon: Hashable {
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
