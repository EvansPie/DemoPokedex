//
//  PokemonView.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import SwiftUI

struct PokemonView: View {
    
    @StateObject private var viewModel: PokemonViewModel
    
    init(model: Pokemon) {
        _viewModel = StateObject(wrappedValue: PokemonViewModel(pokemon: model, evolutionPokemons: model.evolutions.compactMap({ DataService.shared.getPokemon(withName: $0) })))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    AsyncImage(url: viewModel.pokemon.imageUrl) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 350)
                    } placeholder: {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                
                Section(header: Text("Types")
                    .font(.headline)
                    .padding(.top)) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.pokemon.types, id: \.self) { pokemonType in
                                TagView(
                                    title: pokemonType.userFriendlyValue,
                                    backgroundColor: pokemonType.representingColor,
                                    textColor: Color.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                
                Section(header: Text("Abilities")
                    .font(.headline)
                    .padding(.top)) {
                        Text(viewModel.pokemon.abilities.joined(separator: ", "))
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                
                Section(header: Text("Location")
                    .font(.headline)
                    .padding(.top)) {
                        Text(viewModel.pokemon.location)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                
                if viewModel.evolutionPokemons.isEmpty.not {
                    Section(header: Text("Evolutions")
                        .font(.headline)
                        .padding(.top)) {
                            ForEach(viewModel.evolutionPokemons, id: \.id) { evolution in
                                NavigationLink(destination: PokemonView(model: evolution)) {
                                    PokemonCell(pokemon: evolution)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        .navigationTitle(viewModel.pokemon.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        PokemonView(model: Pokemon(
            id: 1000,
            name: "My Pokemon",
            types: [.ghost, .ice],
            abilities: ["Test Ability"],
            hitpoints: 1000,
            evolutions: ["Evolution 1"],
            region: "Kanto",
            road: "Test road",
            imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")!))
    }
}
