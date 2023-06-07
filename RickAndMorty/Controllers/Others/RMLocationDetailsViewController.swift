//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by ULU on 14/05/2023.
//

import UIKit

/// VC to show details about single location
final class RMLocationDetailsViewController: UIViewController {

    private let detailsView = RMLocationDetailsView()
    private let vm: RMLocationDetailsViewViewModel
    
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.vm = RMLocationDetailsViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        detailsView.delegate = self
        vm.delegate = self
        vm.getLocationData()
    }
    
    private func setupUI() {
        title = "Location"
        view.backgroundColor = .systemBackground
        view.addSubview(detailsView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareBtn))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
    
    @objc func didTapShareBtn() {
        
    }
}

extension RMLocationDetailsViewController: RMLocationDetailsViewViewModelDelegate {
    
    func didGetLocationDetails() {
        detailsView.configure(with: vm)
    }
}

extension RMLocationDetailsViewController: RMLocationDetailsViewDelegate {
    
    func rmLocationDetailsView(_ rmLocationDetailsView: RMLocationDetailsView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailsViewController(vm: .init(character: character))
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
