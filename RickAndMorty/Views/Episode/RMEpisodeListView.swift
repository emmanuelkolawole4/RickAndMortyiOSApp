//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by ULU on 27/04/2023.
//

import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeListView(_ rmEpisodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode)
}

/// View that handles showing list of episodes, spinner, etc
final class RMEpisodeListView: UIView {
    
    private let vm = RMEpisodeListViewViewModel()
    weak var delegate: RMEpisodeListViewDelegate?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        vm.delegate = self
        vm.getEpisodes()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
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
    
    private func configureCollectionView() {
        collectionView.dataSource = vm
        collectionView.delegate = vm
    }
}

extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
    
    func didLoadInitialEpisodes() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // note: for initial fetch only. since there's pagination implemented, we don't want to reload the whole collection when we get more data and pop the user back to the top
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreEpisodes(with indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
    
}

