//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import UIKit

/// Controller to show and search for Locations
final class RMLocationViewController: UIViewController {
    
    private let locationListView = RMLocationListView()
    private let vm: RMLocationListViewViewModel
    
    init() {
        self.vm = RMLocationListViewViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        locationListView.delegate = self
        vm.delegate = self
        vm.getLocations()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        view.addSubview(locationListView)
        addConstraints()
        addSearchBtn()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            locationListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            locationListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            locationListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
    
    private func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchBtn))
    }
    
    @objc private func didTapSearchBtn() {
        let vc = RMSearchViewController(config: RMSearchViewController.SearchConfig(type: .location))
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension RMLocationViewController: RMLocationListViewViewModelDelegate {
    
    func didLoadInitialLocations() {
        locationListView.configure(with: vm)
    }
    
    func didLoadMoreLocations(with indexPaths: [IndexPath]) {
        
    }
    
}

extension RMLocationViewController: RMLocationListViewDelegate {
    
    func rmLocationListView(_ rmLocationListView: RMLocationListView, didSelectLocation location: RMLocation) {
        let detailVC = RMLocationDetailsViewController(location: location)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
