//
//  HomeView.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import DemoPokedexCoreKit
import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                /// ✨ Tbh, the 3 states below could just be an `enum HomeViewState` with cases
                /// `loading`, `error`, and `default(visibleDataSource: [Element]`
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    // Show error message if there is an error
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.visibleDataSource, id: \.id) { pokemon in
                        NavigationLink(destination: PokemonView(model: pokemon)) {
                            PokemonCell(pokemon: pokemon)
                        }
                    }
                    .navigationTitle("Pokédex")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                viewModel.isFiltersPresented.toggle()
                            }) {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                                    .font(.title2)
                            }
                            .sheet(isPresented: $viewModel.isFiltersPresented) {
                                FiltersView(
                                    currentFilters: viewModel.currentFilters,
                                    onApplyFilters: { filters in
                                        viewModel.applyFilters(filters)
                                    })
                            }
                            .accessibilityIdentifier("filtersButton")
                        }
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                // Show an alert if there's a recovery suggestion
                Alert(
                    title: Text("Error Occurred"),
                    message: Text(viewModel.recoverySuggestion ?? "Something went wrong. Please try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    HomeView()
}

