//
//  DataService.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation
import DemoPokedexCoreKit

@MainActor
class DataService: ObservableObject {
    
    // MARK: - INITIALIZATION
    
    // MARK: Singleton
    static let shared = DataService()
    private init() {}
    
    
    // MARK: - PUBLIC API
    
    // At the moment, `pokemons` doesn't need to be `@Published` since there're no listeners.
    @Published private(set) var pokemons: [Pokemon] = []
    
    /// Fetch and store Pokemon data
    /// This function uses a default `APIClient`, but we can inject a `MockAPIClient`
    @discardableResult
    public nonisolated func fetchPokemons(with apiClient: APIClientProtocol = APIClient(), enforceRefresh: Bool = false) async throws -> [Pokemon] {
        let currentPokemons = await self.pokemons
        
        /// Only fetch new data if we don't have any `pokemons` stored or if `enforceRefresh == true`
        if currentPokemons.isEmpty.not && enforceRefresh.not {
            print("\(apiClient is MockAPIClient ? "[MOCK DATA] " : "")Returning stored pokemons...")
            return currentPokemons
        }
        
        print("\(apiClient is MockAPIClient ? "[MOCK DATA] " : "")Fetching pokemons...")
        
        /// The request is going to happen on the background thread from the `DemoPokedexCoreKit`
        let fetchedPokemons: [Pokemon] = try await apiClient.request(
            endpoint: API.fetchPokemons,
            responseType: [Pokemon].self
        ).unique
        
        await MainActor.run {
            self.pokemons = fetchedPokemons
        }
        
        print("\(apiClient is MockAPIClient ? "[MOCK DATA] " : "")Pokemons fetched and stored.")
        return fetchedPokemons
    }
    
    /// This function is used in the `PokemonView` in order to push to another `PokemonView`. The function assumes that
    /// names are unique. The issue arises from the API returning Pokemon names in the `Pokemon.evolutions` array,
    /// instead of Pokemon IDs.
    public func getPokemon(withName name: String) -> Pokemon? {
        let pokemon = pokemons.first(where: { $0.name == name })
        return pokemon
    }
    
    public func getPokemonAsync(withName name: String) async -> Pokemon? {
        /// Just in case we have a very large amount of pokemons
        /// `Task.detached` runs async, concurrent, and independent of the parent task
        return await Task.detached { [weak self] in
            guard let strongSelf = self else { return nil }
            let pokemon = await strongSelf.pokemons.first(where: { $0.name == name })
            return await MainActor.run { pokemon }
        }.value
    }
}
