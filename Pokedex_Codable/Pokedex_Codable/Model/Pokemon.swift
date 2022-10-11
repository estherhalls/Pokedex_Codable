//
//  Pokemon.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation

struct Pokedex: Decodable {
    let results: [PokemonResults]
    let next: String
}

struct PokemonResults: Decodable {
    let name: String
    let url: String
}

struct Pokemon: Decodable {
    let sprites: Sprites
    let name: String
    let id: Int
    let weight: Int
    let moves: [Move]
}

struct Move: Decodable {
    let name: String
}

struct Sprites: Decodable {
    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
    
    let frontDefault: String
    let frontFemale: String?
    let frontShiny: String
    let frontShinyFemale: String?
}
