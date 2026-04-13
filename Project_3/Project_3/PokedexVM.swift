
//
//  PokedexCell.swift
//  Project_3
//
//  Created by Smith01, Griffin on 4/13/26.
//
import UIKit
import Alamofire

struct PokemonListResponse : Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [PokemonEntry]
}
struct PokemonEntry : Codable, Hashable {
    let name: String
    let url: String
    //https://stackoverflow.com/questions/43118687/split-url-query-in-swift
    var id: Int? {
        let components = url.split(separator: "/")
        return Int(components.last ?? "")
    }
    var spriteURL: URL? {
        if let id {
            return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png") } else {
                return nil
        }
    }
}
    
    class PokedexViewModel : NSObject {
        
        var pokemon : [PokemonEntry] = []
        var onDataUpdated: (() -> Void)?
        
        override init() {
            super.init()
//            fetchAllData(completion: nil)
        }
        
        
        // Swift auto suggested this function
        func fetchAllData(completion: (() -> Void)? = nil) {
            let urlString = "https://pokeapi.co/api/v2/pokemon/?limit=151"
            print("Test")
            AF.request(urlString).responseDecodable(of: PokemonListResponse.self) { response in
                switch response.result {
                case .success(let listResponse):
                    self.pokemon = listResponse.results
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
