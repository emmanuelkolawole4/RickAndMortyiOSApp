//
//  RMCharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by ULU on 19/04/2023.
//

import UIKit

/// Controller to show info about single Character
final class RMCharacterDetailsViewController: UIViewController {
    
    private let vm: RMCharacterDetailsViewViewModel
    
    init(vm: RMCharacterDetailsViewViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = vm.title
    }
}
