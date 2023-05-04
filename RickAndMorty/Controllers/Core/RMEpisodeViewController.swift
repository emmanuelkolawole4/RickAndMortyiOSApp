//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import UIKit

/// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {

    private let episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Episodes"
        
        view.addSubview(episodeListView)
        addConstraints()
        addSearchBtn()
    }
    
    private func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchBtn))
    }

    private func addConstraints() {
        episodeListView.delegate = self
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
    
    @objc private func didTapSearchBtn() {
        
    }

}

extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    
    func rmEpisodeListView(_ rmEpisodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        let detailVC =  RMEpisodeDetailsViewController(url: URL(string: episode.url)) //RMCharacterDetailsViewController(vm: vm)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
