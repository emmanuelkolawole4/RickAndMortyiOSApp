//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {
    
    private let characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        view.addSubview(characterListView)
        addConstraints()
        addSearchBtn()
    }
    
    private func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchBtn))
    }

    private func addConstraints() {
        characterListView.delegate = self
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
    
    @objc private func didTapSearchBtn() {
        let vc = RMSearchViewController(config: RMSearchViewController.SearchConfig(type: .character))
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RMCharacterViewController: RMCharacterListViewDelegate {
    
    func rmCharacterListView(_ rmCharacterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let vm = RMCharacterDetailsViewViewModel(character: character)
        let detailVC = RMCharacterDetailsViewController(vm: vm)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
