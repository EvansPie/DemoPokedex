//
//  PokemonCell.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import SwiftUI

struct PokemonCell: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            // Pokemon Image
            AsyncImage(url: pokemon.imageUrl) { image in
                image.resizable()
                     .scaledToFit()
                     .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                // Pokemon Name - Set color to black
                Text(pokemon.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                // Location under Pokemon name (label font)
                Text(pokemon.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Display types as tags
                HStack(spacing: 8) {
                    ForEach(pokemon.types, id: \.self) { pokemonType in
                        TagView(
                            title: pokemonType.userFriendlyValue,
                            backgroundColor: pokemonType.representingColor,
                            textColor: Color.white)
                    }
                }
                .padding(.top, 4)
                
                // Display hitpoints as subtitle
                Text("HP: \(pokemon.hitpoints)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

#Preview {
    PokemonCell(pokemon: Pokemon(
        id: 4,
        name: "Charmeleon",
        types: [.fire],
        abilities: ["Blaze", "Solar Power"],
        hitpoints: 58,
        evolutions: ["Charizard"],
        region: "Kanto",
        road: "Route 4",
        imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")!))
}
