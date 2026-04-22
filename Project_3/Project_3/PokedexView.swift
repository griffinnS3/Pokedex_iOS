//
//  ViewController.swift
//  Project_3
//
//  Created by Smith01, Griffin on 4/13/26.
//

import UIKit

//From Apples Sample Code on Modern Collection Views

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PokemonEntry>! = nil
    var collectionView: UICollectionView! = nil
    let vm = PokedexViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pokédex"
        configureHierarchy()
        configureDataSource()
        //Claude helped me with updating the view
        vm.onDataUpdated = { [weak self] in
            self?.applySnapshot()
        }
        vm.fetchAllData()
    }
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonEntry>()
        snapshot.appendSections([.main])
        snapshot.appendItems(vm.pokemon)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension GridViewController {
    /// - Tag: Grid
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

extension GridViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<PokedexCell, PokemonEntry> { (cell, indexPath, identifier) in
            cell.configure(entry: identifier)
            cell.contentView.backgroundColor = .systemBlue
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            //https://www.dafont.com/pokemon.font
            cell.label.font = UIFont(name: "PokemonSolidNormal", size: 48)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PokemonEntry>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, entry: PokemonEntry) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: entry)
        }
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonEntry>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
extension GridViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let entry = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = PokemonDetailView(pokemon: entry)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
