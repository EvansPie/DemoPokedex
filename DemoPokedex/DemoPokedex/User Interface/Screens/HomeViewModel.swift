//
//  HomeViewModel.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation
import DemoPokedexCoreKit

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var visibleDataSource: [Pokemon] = []
    @Published var isLoading: Bool = true
    @Published var isFiltersPresented: Bool = false
    @Published var currentFilters: FiltersAndSortingOptions? = nil
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    @Published var recoverySuggestion: String? = nil
    
    init() {
        self.fetchData()
    }
    
    func fetchData() {
        isLoading = true
        errorMessage = nil // Reset error message before starting fetch
        Task {
            do {
                /// ⚠️ ⚠️⚠️
                /// In case *dummyapi.online* is still down and you aren't familiar with how to run the **Node.js** local server,
                /// you can uncomment the lines below and use mock data
                ///
                /// 👇 **MOCK DATA**
                let mockData = try Mocks.getPokemonsDataFromLocalJSON()
                let mockApiClient = MockAPIClient(data: mockData, error: nil)
                self.visibleDataSource = try await DataService.shared.fetchPokemons(with: mockApiClient, enforceRefresh: true)
                /// 👇 **REMOTE REQUEST**
                /// Set `DevelopmentEnvironment.current` to `.local` to get the response from the local server
//                self.visibleDataSource = try await DataService.shared.fetchPokemons(enforceRefresh: true)
                self.isLoading = false
            } catch {
                if let customError = error as? CustomError {
                    self.errorMessage = customError.description
                    
                    if let recoverySuggestion = customError.recoverySuggestion {
                        self.recoverySuggestion = recoverySuggestion
                        self.showAlert = true // Show alert if recovery suggestion exists
                    }
                } else {
                    self.errorMessage = error.localizedDescription
                }
                
                self.isLoading = false
            }
        }
        
    }
    
    func applyFilters(_ filters: FiltersAndSortingOptions) {
        self.currentFilters = filters
        self.visibleDataSource = FilterAndSort.filterAndSortPokemons(DataService.shared.pokemons, with: filters)
    }
}

