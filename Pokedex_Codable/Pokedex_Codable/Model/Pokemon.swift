//
//  Pokemon.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation

// Top Level Dictionary
struct Pokedex: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Decodable {
    let name: String
    let url: String
}
