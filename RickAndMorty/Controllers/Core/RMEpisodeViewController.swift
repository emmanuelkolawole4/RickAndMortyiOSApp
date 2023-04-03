//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import UIKit

/// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Episodes"
    }

}
