//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import UIKit

final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Locations"
    }

}