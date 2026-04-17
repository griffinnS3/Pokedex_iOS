//
//  PokemonDetailVM.swift
//  Project_3
//
//  Created by Smith01, Griffin on 4/17/26.
//
import Alamofire
import UIKit

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int
    let types: [TypeSlot]
    let stats: [StatEntry]
    let abilities: [AbilitySlot]
    let moves: [MoveEntry]


enum CodingKeys: String, CodingKey {
    case id
    case name
    case height
    case weight
    case baseExperience = "base_experience"
    case types
    case stats
    case abilities
    case moves
    }
}

struct TypeSlot: Codable {
    let slot: Int
    let type: PokemonType
}
struct PokemonType: Codable {
    let name: String
    let url: String
}
struct StatEntry: Codable {
    let baseStat: Int
    let effort: Int
    let stat: StatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}
struct StatInfo: Codable {
    let name: String
    let url: String
}

struct AbilityInfo: Codable {
    let name: String
    let url: String
}
struct MoveEntry: Codable {
    let move: MoveInfo
    enum CodingKeys: String, CodingKey {
        case move
    }
}
    struct AbilitySlot: Codable {
        let isHidden: Bool
        let slot: Int
        let ability: AbilityInfo
        
        enum CodingKeys: String, CodingKey {
            case isHidden = "is_hidden"
            case slot
            case ability
        }
    }
struct MoveInfo: Codable {
    let name: String
    let url: String
}


class PokemonDetailViewModel: NSObject {
    
    var detail: PokemonDetail?
    var onDataUpdated: (() -> Void)?
    
    // Convenience accessors for the view
    var typesDisplay: String {
        detail?.types
            .sorted { $0.slot < $1.slot }
            .map { $0.type.name.capitalized }
            .joined(separator: " / ") ?? ""
    }
    
    var statsDisplay: [(name: String, value: Int)] {
        detail?.stats.map { ($0.stat.name.capitalized, $0.baseStat) } ?? []
    }
    
    var movesDisplay: [String] {
        detail?.moves.map { $0.move.name.capitalized } ?? []
    }
    
    var abilitiesDisplay: [(name: String, isHidden: Bool)] {
        detail?.abilities.map { ($0.ability.name.capitalized, $0.isHidden) } ?? []
    }
    
    func fetchDetail(from url: String) {
        AF.request(url).responseDecodable(of: PokemonDetail.self) { response in
            switch response.result {
            case .success(let detail):
                self.detail = detail
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            case .failure(let error):
                print("Failed to fetch detail: \(error)")
            }
        }
    }
}

