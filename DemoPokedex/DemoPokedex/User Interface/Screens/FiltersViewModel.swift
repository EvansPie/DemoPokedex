//
//  FiltersViewModel.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 3/2/25.
//

import Foundation
import DemoPokedexCoreKit

@MainActor
class FiltersViewModel: ObservableObject {
    
    @Published var selectedSortingOption: SortOption?
    @Published var selectedPokemonType: PokemonType?
    @Published var selectedRegionOption: String?

    let sortingOptions = SortOption.allCases
    let pokemonTypes = PokemonType.allCases
    let regions: [String]

    let currentFilters: FiltersAndSortingOptions?
    let onApplyFilters: (FiltersAndSortingOptions) -> Void

    init(currentFilters: FiltersAndSortingOptions?, onApplyFilters: @escaping (FiltersAndSortingOptions) -> Void) {
        self.currentFilters = currentFilters
        self.onApplyFilters = onApplyFilters

        // Initialize regions
        self.regions = DataService.shared.pokemons.map { $0.region }.unique.sorted()

        // Set initial values from currentFilters
        self.selectedSortingOption = currentFilters?.sortingOption
        self.selectedPokemonType = currentFilters?.pokemonType
        self.selectedRegionOption = currentFilters?.region
    }

    func clearFilters() {
        selectedSortingOption = nil
        selectedPokemonType = nil
        selectedRegionOption = nil
    }

    func applyFilters() {
        let filters = FiltersAndSortingOptions(
            pokemonType: selectedPokemonType,
            region: selectedRegionOption,
            sortingOption: selectedSortingOption
        )
        onApplyFilters(filters)
    }
}
