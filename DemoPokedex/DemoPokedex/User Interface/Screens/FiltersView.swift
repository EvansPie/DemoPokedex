//
//  FiltersView.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import SwiftUI
import TagKit

struct FiltersView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: FiltersViewModel

    init(currentFilters: FiltersAndSortingOptions?, onApplyFilters: @escaping (FiltersAndSortingOptions) -> Void) {
        _viewModel = StateObject(wrappedValue: FiltersViewModel(currentFilters: currentFilters, onApplyFilters: onApplyFilters))
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 40) {
                // Section 1: Sort
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sort")
                        .font(.headline)
                    TagList(tags: viewModel.sortingOptions.compactMap { $0.rawValue }, tagView: { sortingOptionRawValue in
                        TagView(
                            title: SortOption(rawValue: sortingOptionRawValue)!.userFriendlyValue,
                            isSelected: viewModel.selectedSortingOption?.rawValue == sortingOptionRawValue,
                            onTap: {
                                viewModel.selectedSortingOption = (viewModel.selectedSortingOption?.rawValue == sortingOptionRawValue) ? nil : SortOption(rawValue: sortingOptionRawValue)
                            })
                    })
                }

                // Section 2: Type
                VStack(alignment: .leading, spacing: 16) {
                    Text("Type")
                        .font(.headline)
                    TagList(tags: viewModel.pokemonTypes.compactMap { $0.rawValue }, tagView: { pokemonTypeRawValue in
                        TagView(
                            title: PokemonType(rawValue: pokemonTypeRawValue)!.userFriendlyValue,
                            isSelected: viewModel.selectedPokemonType?.rawValue == pokemonTypeRawValue,
                            onTap: {
                                viewModel.selectedPokemonType = (viewModel.selectedPokemonType?.rawValue == pokemonTypeRawValue) ? nil : PokemonType(rawValue: pokemonTypeRawValue)
                            })
                    })
                }

                // Section 3: Region
                VStack(alignment: .leading, spacing: 16) {
                    Text("Region")
                        .font(.headline)
                    TagList(tags: viewModel.regions, tagView: { region in
                        TagView(
                            title: region,
                            isSelected: viewModel.selectedRegionOption == region,
                            onTap: {
                                viewModel.selectedRegionOption = (viewModel.selectedRegionOption == region) ? nil : region
                            })
                    })
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        viewModel.clearFilters()
                        viewModel.applyFilters()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        viewModel.applyFilters()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FiltersView(currentFilters: nil, onApplyFilters: { filters in
        // Handle applied filters in the preview
    })
}
