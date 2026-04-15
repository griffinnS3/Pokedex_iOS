//
//  PokemonDetailView.swift
//  Project_3
//
//  Created by Smith01, Griffin on 4/15/26.
//
import UIKit
import Kingfisher
import SnapKit


class PokemonDetailView: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let pokemon: PokemonEntry
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    
    init(pokemon: PokemonEntry) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
        
    }
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        navigationItem.title = pokemon.name
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        nameLabel.text = pokemon.name
        
        if let spriteURL = pokemon.spriteURL {
            imageView.kf.setImage(with: spriteURL, placeholder: UIImage(systemName: "photo"),
                                  options: [.transition(.fade(0.3))])
        }
    }
    
}
