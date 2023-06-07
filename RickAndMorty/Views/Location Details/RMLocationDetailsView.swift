//
//  RMLocationDetailsView.swift
//  RickAndMorty
//
//  Created by ULU on 14/05/2023.
//

import UIKit

protocol RMLocationDetailsViewDelegate: AnyObject {
    func rmLocationDetailsView(_ rmLocationDetailsView: RMLocationDetailsView, didSelect character: RMCharacter)
}

final class RMLocationDetailsView: UIView {
    
    private var collectionView: UICollectionView?
    weak var delegate: RMLocationDetailsViewDelegate?
    
    private var vm: RMLocationDetailsViewViewModel? {
        didSet {
            spinner.stopAnimating()
            collectionView?.reloadData()
            collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIdx, _ in
            self.createLayout(for: sectionIdx)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.identifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
    
    func configure(with vm: RMLocationDetailsViewViewModel) {
        self.vm = vm
    }
    
    
}

extension RMLocationDetailsView {
    
    private func createLayout(for sectionIdx: Int) -> NSCollectionLayoutSection {
        guard let sections = vm?.cellViewModelsSections else {
            return createInfoLayout()
        }
        
        switch sections[sectionIdx] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }
    
    private func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(272.25)
            ),
            subitems: [item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension RMLocationDetailsView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vm?.cellViewModelsSections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = vm else { return 0 }
        let sectionType = vm.cellViewModelsSections[section]

        switch sectionType {
        case .information(let vms):
            return vms.count
        case .characters(let vms):
            return vms.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vm = vm else { fatalError("No ViewModel") }
        let sectionType = vm.cellViewModelsSections[indexPath.section]

        switch sectionType {
        case .information(let vms):
            let cellVM = vms[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.identifier,
                for: indexPath
            ) as? RMEpisodeInfoCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: cellVM)
            return cell
        case .characters(let vms):
            let cellVM = vms[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.identifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: cellVM)
            return cell
        }
    }
    
    
}

 extension RMLocationDetailsView: UICollectionViewDelegate {
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         collectionView.deselectItem(at: indexPath, animated: true)
//
//         guard let vm = vm else { fatalError("No ViewModel") }
//         let sections = vm.cellViewModelsSections
//         let sectionType = sections[indexPath.section]
//
//         switch sectionType {
//         case .information:
//             break
//         case .characters:
//             guard let character = vm.character(at: indexPath.row) else { return }
//             delegate?.rmEpisodeDetailsView(self, didSelect: character)
//         }
     }
 }

 
 

