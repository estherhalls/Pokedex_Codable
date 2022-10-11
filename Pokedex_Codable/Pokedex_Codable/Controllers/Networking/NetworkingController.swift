//
//  NetworkingController.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation
import UIKit.UIImage

class NetworkingController {
    
    // Base URL
    private static let baseURLString = "https://pokeapi.co"
    
    // URL Component Keys
    private static let kApiComponent = "api"
    private static let kV2Component = "v2"
    private static let kPokemonComponent = "pokemon"
    
    static func fetchPokedex(completion: @escaping (Result<Pokedex, ResultError>) -> Void) {
        // Create the URL
        guard let baseURL = URL(string: baseURLString) else { completion(.failure(.invalidURL(baseURLString)))
            return }
        let apiURL = baseURL.appendingPathComponent(kApiComponent)
        let v2URL = apiURL.appendingPathComponent(kV2Component)
        let finalURL = v2URL.appendingPathComponent(kPokemonComponent)
        
        // Step 2 Data Task
        URLSession.shared.dataTask(with: finalURL) { dTaskError, _, error in
            if let error {
                completion(.failure(.thrownError(error)))
            }
            // Check for data
            guard let unwrappedData = dTaskError else {
                completion(.failure(.noData))
                // Return here because it is a guard statement
                return
            }
            // Do/Try/Catch
            do {
                let pokedexData = try JSONDecoder().decode(Pokedex.self, from: unwrappedData)
                completion(.success(pokedexData))
            } catch {
                completion(.failure(.unableToDecode)); return
            }
            
            // Resume takes it out of suspended mode - starts and resumes as needed
        }.resume()
        
    }
    
    
    static func fetchPokemon(with urlString: String, completion: @escaping (Result<Pokemon, ResultError>) -> Void) {
        guard let finalURL = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return
            
        }
        
        URLSession.shared.dataTask(with: finalURL) { dTaskData, _, error in
            if let error = error {
                print("Encountered error: \(error.localizedDescription)")
                completion(.failure(.thrownError(error)))
            }
            
            guard let pokemonData = dTaskData else {
                completion(.failure(.noData))
                return}
            
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: pokemonData)
                completion(.success(pokemon))
            } catch {
                print("Encountered error when decoding the data:", error.localizedDescription)
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    
    static func fetchImage(for imageString: String, completion: @escaping (Result<UIImage, ResultError>) -> Void) {
        guard let imageURL = URL(string: imageString) else {
            completion(.failure(.invalidURL(imageString)))
            return}
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("There was an error", error.localizedDescription)
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            guard let pokemonImage = UIImage(data: data) else {
                completion(.failure(.unableToDecode))
                return }
            completion(.success(pokemonImage))
        }.resume()
    }
}// end
