//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import UIKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Settings"
    }

}
