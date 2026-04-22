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
    // I got help from claude to fetch the data and cache it
    static var cache: [String: PokemonDetail] = [:]
    let fetchGroup = DispatchGroup()
    var isFetching = false
    
    
    func fetchDetail(from url: String, retryCount: Int = 0) {
        if let cached = Self.cache[url] {
            print("Cache hit for \(url)")
            self.detail = cached
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
            return
        }
        
        guard !isFetching else { return }
        isFetching = true
        
        AF.request(url).responseDecodable(of: PokemonDetail.self) { response in
            self.isFetching = false
            switch response.result {
            case .success(let detail):
                print("Fetched: \(detail.name)")
                Self.cache[url] = detail
                self.detail = detail
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            case .failure(let error):
                print("Failed: \(error)")
            }
        }
    }
}
extension PokemonDetailView {
    func applySnapshot() {
        guard let detail = vm.detail else {
            print("applySnapshot called but vm.detail is nil")
            return
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(
            detail.types.sorted { $0.slot < $1.slot }.map { .type($0.type.name.capitalized) }
        )
        snapshot.appendItems(
            detail.stats.map { .stat(name: $0.stat.name.capitalized, value: $0.baseStat) }
        )
        snapshot.appendItems(
            detail.abilities.map { .ability(name: $0.ability.name.capitalized, isHidden: $0.isHidden) }
        )
        snapshot.appendItems(
            detail.moves.map { .move($0.move.name.capitalized) }
        )
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

