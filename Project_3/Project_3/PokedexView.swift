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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.2))
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
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PokemonEntry>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, entry: PokemonEntry) -> UICollectionViewCell? in
            // Return the cell.
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
        if let entry = dataSource.itemIdentifier(for: indexPath) {
            let detailViewController = PokemonDetailView(pokemon: entry)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
