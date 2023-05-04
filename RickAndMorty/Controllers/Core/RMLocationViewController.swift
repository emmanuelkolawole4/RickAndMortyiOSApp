//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import UIKit

/// Controller to show and search for Locations
final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchBtn()
    }
    
    private func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchBtn))
    }
    
    @objc private func didTapSearchBtn() {
        let vc = RMSearchViewController(config: RMSearchViewController.SearchConfig(type: .location))
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.largeTitleDisplayMode = .never
    }
}
