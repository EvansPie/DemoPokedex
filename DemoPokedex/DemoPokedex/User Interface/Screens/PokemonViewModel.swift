//
//  PokemonViewModel.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

class PokemonViewModel: ObservableObject {
    
    @Published var pokemon: Pokemon
    
    @Published var evolutionPokemons: [Pokemon]
    
    init(pokemon: Pokemon, evolutionPokemons: [Pokemon]) {
        self.pokemon = pokemon
        self.evolutionPokemons = evolutionPokemons
    }
}
