//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by ULU on 26/04/2023.
//

import UIKit

/// VC to show details about single episode
final class RMEpisodeDetailsViewController: UIViewController {
    
    private let detailsView = RMEpisodeDetailsView()
    private let vm: RMEpisodeDetailsViewViewModel
    
    init(url: URL?) {
        self.vm = RMEpisodeDetailsViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Episode"
        view.addSubview(detailsView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareBtn))
        detailsView.delegate = self
        vm.delegate = self
        vm.getEpisodeData()
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

extension RMEpisodeDetailsViewController: RMEpisodeDetailsViewViewModelDelegate {
    
    func didGetEpisdeDetails() {
        detailsView.configure(with: vm)
    }
}

extension RMEpisodeDetailsViewController: RMEpisodeDetailsViewDelegate {
    
    func rmEpisodeDetailsView(_ rmEpisodeDetailsView: RMEpisodeDetailsView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailsViewController(vm: .init(character: character))
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
