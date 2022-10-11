//
//  PokedexTableViewController.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import UIKit

class PokedexTableViewController: UITableViewController {
    
    var pokedexResults: [PokemonResults] = []
    var pokedex: Pokedex?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingController.fetchPokedex(with: URL(string: "https://pokeapi.co/api/v2/pokemon")!) { [weak self] result in
            switch result {
            case .success(let pokedex):
                self?.pokedexResults = pokedex.results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokedexResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as? PokemonTableViewCell else {return UITableViewCell()}
        let pokemonURLString = pokedexResults[indexPath.row].url
        cell.updateViews(pokemonURlString: pokemonURLString)
        return cell
    }
    
    // Pagination
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastPokedexIndex = pokedexResults.count - 1
        guard let pokedex = pokedex,
              let nextURLString = (pokedex.next) else {return}
        
        if indexPath.row == lastPokedexIndex {
            NetworkingController.fetchPokemon(with: nextURLString) { result in
                switch result {
                case .success(let pokedex):
                    self.pokedex = pokedex
                    self?.pokedexResults.append(pokedex.results)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print("There was an error!", error.errorDescription!)
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailVC",
              let pokemonViewController = segue.destination as? PokemonViewController,
              let selectedRow = tableView.indexPathForSelectedRow?.row else {return}
        let pokemonToSend = pokedexResults[selectedRow]
        NetworkingController.fetchPokemon(with: pokemonToSend.url) { result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    pokemonViewController.pokemon = pokemon
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }
} // End of Class
