//
//  FilterAndSort.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

class FilterAndSort {
    
    // MARK: - PUBLIC API
    
    public static func filterAndSortPokemons(_ pokemons: [Pokemon], with filters: FiltersAndSortingOptions) -> [Pokemon] {
        /// ✨ If we were handling a large amount of data we could perform the different filters concurrently and then use
        /// a Set's intersection to find the common elements. See sample implementation at the bottom of this file.
        var tmpPokemons: [Pokemon] = pokemons
        
        if let pokemonType = filters.pokemonType {
            tmpPokemons = FilterAndSort.filterPokemons(tmpPokemons, with: pokemonType)
        }
        
        if let region = filters.region {
            tmpPokemons = FilterAndSort.filterPokemons(tmpPokemons, with: region)
        }
        
        if let sortingOption = filters.sortingOption {
            tmpPokemons = FilterAndSort.sortPokemons(tmpPokemons, with: sortingOption)
        }
        
        return tmpPokemons
    }
    
    // MARK: - PRIVATE API
    
    private static func filterPokemons(_ pokemons: [Pokemon], with pokemonType: PokemonType) -> [Pokemon] {
        return pokemons.filter({ $0.types.contains(pokemonType) })
    }
    
    private static func filterPokemons(_ pokemons: [Pokemon], with region: String) -> [Pokemon] {
        return pokemons.filter({ $0.region == region })
    }
    
    private static func sortPokemons(_ pokemons: [Pokemon], with sortingOption: SortOption) -> [Pokemon] {
        switch sortingOption {
        case .alphabetically:
            return pokemons.sorted(by: { $0.name < $1.name })
        case .hitpointsAscending:
            return pokemons.sorted(by: { $0.hitpoints < $1.hitpoints })
        case .hitpointsDescending:
            return pokemons.sorted(by: { $0.hitpoints > $1.hitpoints })
        }
    }
    
    
}

/// ✨ Sample implementation of using a `Filterable` protocol

extension FilterAndSort {
    
    public static func filter<T: Filterable>(dataSource: [T], with filters: FiltersProtocol) -> [T] {
        var filteredData = dataSource
        
        if let filterName = filters.name {
            filteredData = filteredData.filter { $0.name.contains(filterName) }
        }
        
        return filteredData
    }
}

protocol Filterable {
    var name: String { get }
}

extension Pokemon: Filterable {
    
}

protocol FiltersProtocol {
    var name: String? { get }
}

/// ✨ Sample implementation of filtering concurrently

extension FilterAndSort {
    
    public static func filterAndSortPokemonsAsync(
        _ pokemons: [Pokemon],
        with filters: FiltersAndSortingOptions
    ) async -> [Pokemon] {
        let results = await withTaskGroup(of: [Pokemon].self) { group in
            let filteredByType: [Pokemon] = pokemons
            let filteredByRegion: [Pokemon] = pokemons
            
            if let pokemonType = filters.pokemonType {
                group.addTask {
                    return FilterAndSort.filterPokemons(filteredByType, with: pokemonType)
                }
            }
            
            if let region = filters.region {
                group.addTask {
                    return FilterAndSort.filterPokemons(filteredByRegion, with: region)
                }
            }
            
            var filteredPokemonsSet: Set<Pokemon>? = nil

            for await result in group {
                let resultSet = Set(result)
                if let currentSet = filteredPokemonsSet {
                    filteredPokemonsSet = currentSet.intersection(resultSet)
                } else {
                    filteredPokemonsSet = resultSet
                }
            }
            
            let filteredPokemonsArray = filteredPokemonsSet == nil ? pokemons : Array(filteredPokemonsSet ?? [])
            
            if let sortingOption = filters.sortingOption {
                return self.sortPokemons(filteredPokemonsArray, with: sortingOption)
            } else {
                return filteredPokemonsArray
            }
        }
        
        return results
    }

}
