//
//  API.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation
import DemoPokedexCoreKit

enum API: APIEndpoint {
    
    case fetchPokemons
    case fetchPokemon(id: Int)
    
    var baseURL: URL {
        switch DevelopmentEnvironment.current {
        case .local:
            return URL(string: "http://localhost:8000")!
        case .dev:
            return URL(string: "http://dummyapi.online")!
        }
    }
    
    var apiVersion: String? {
        switch self {
        case .fetchPokemons,
                .fetchPokemon:
            return "/api"
        }
    }
    
    var path: String? {
        switch self {
        case .fetchPokemons:
            return "/pokemon"
        case .fetchPokemon(let id):
            return "/pokemon/\(id)"
        }
    }
    
    var method: APIMethod {
        switch self {
        case .fetchPokemons,
                .fetchPokemon:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchPokemons,
                .fetchPokemon:
            return nil
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchPokemons,
                .fetchPokemon:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchPokemons,
                .fetchPokemon:
            return nil
        }
    }
}
