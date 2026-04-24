//
//  PokemonDetailView.swift
//  Project_3
//
//  Created by Smith01, Griffin on 4/15/26.
//
import UIKit
import Kingfisher
import SnapKit

// Taken from Apples sample code

enum Section {
    case leading
    case trailing
}

class PokemonDetailView: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let pokemon: PokemonEntry
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let vm = PokemonDetailViewModel()
    let background = UILabel()
    
    enum Section {
        case main
    }
    enum Item: Hashable {
        case type(String)
        case stat(name: String, value: Int)
        case ability(name: String, isHidden: Bool)
        case move(String)
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var collectionView: UICollectionView! = nil
    
    
    init(pokemon: PokemonEntry) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
        print("Detail view created for: \(pokemon.name)")
        
    }
    override func viewDidLoad() {
        /*view.backgroundColor = .systemBackground
        navigationItem.title = pokemon.name
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        nameLabel.text = pokemon.name
        
        if let spriteURL = pokemon.spriteURL {
            imageView.kf.setImage(with: spriteURL, placeholder: UIImage(systemName: "photo"),
                                  options: [.transition(.fade(0.3))])
        }*/
        
        super.viewDidLoad()
        navigationItem.title = pokemon.name.capitalized
        configureHierarchy()
        configureDataSource()
            
            if let spriteURL = pokemon.spriteURL {
                imageView.kf.setImage (with: spriteURL,
                 placeholder: UIImage(systemName: "photo"),
                 options: [.transition(.fade(0.3))])
            }
        
        vm.onDataUpdated = { [weak self] in

            self?.applySnapshot()
        }
        vm.fetchDetail(from: pokemon.url)
    }
    
}

extension PokemonDetailView {

    //   +-----------------------------------------------------+
    //   | +---------------------------------+  +-----------+  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |     1     |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  +-----------+  |
    //   | |               0                 |                 |
    //   | |                                 |  +-----------+  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |     2     |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | +---------------------------------+  +-----------+  |
    //   +-----------------------------------------------------+

    /// - Tag: Nested
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.28)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.14)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let leadingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0)),
                repeatingSubitem: leadingItem,
                count: 3)
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0)),
                repeatingSubitem: trailingItem,
                count: 6)
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.9)),
                subitems: [leadingGroup, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section

        }
        return layout
    }
}

extension PokemonDetailView {
   func configureHierarchy() {
       view.addSubview(background)
       view.addSubview(imageView)
       imageView.snp.makeConstraints { make in
           make.top.equalTo(view.safeAreaLayoutGuide)
           make.centerX.equalToSuperview()
           make.width.equalTo(view.safeAreaLayoutGuide).dividedBy(3)
           make.height.equalTo(200)
       }
       background.backgroundColor = .systemBackground
       background.snp.makeConstraints { make in
           make.width.equalTo(view.safeAreaLayoutGuide)
           make.centerX.equalToSuperview()
           make.top.equalTo(imageView.snp.top)
           make.bottom.equalTo(imageView.snp.bottom)
       }
       imageView.backgroundColor = .systemBackground
       collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
       collectionView.snp.makeConstraints { make in
           make.top.equalTo(imageView.snp.bottom)
           make.bottom.equalToSuperview()
           make.leading.trailing.equalToSuperview()
       }
        collectionView.delegate = self
    }
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<DebugCell, Item> { (cell, indexPath, item) in
            switch item {
            case .type(let name):
                cell.configure(text: "TYPE\n\(name)", color: .systemBlue.withAlphaComponent(0.2))
            case .stat(let name, let value):
                cell.configure(text: "\(name)\n\(value)", color: .systemGreen.withAlphaComponent(0.2))
            case .ability(let name, let isHidden):
                cell.configure(text: "ABILITY\n\(name)\n\(isHidden ? "(hidden)" : "")", color: .systemPurple.withAlphaComponent(0.2))
            case .move(let name):
                cell.configure(text: "MOVE\n\(name)", color: .systemOrange.withAlphaComponent(0.2))
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.type("Grass"), .type("Poison"), .stat(name: "HP", value: 45), .move("Tackle")])
        dataSource.apply(snapshot, animatingDifferences: false)
    }}

extension PokemonDetailView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
