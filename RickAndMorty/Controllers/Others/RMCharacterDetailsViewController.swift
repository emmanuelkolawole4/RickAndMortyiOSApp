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
    private let detailsView: RMCharacterDetailsView
    
    
    init(vm: RMCharacterDetailsViewViewModel) {
        self.vm = vm
        self.detailsView = RMCharacterDetailsView(frame: .zero, vm: vm)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsView.collectionView?.dataSource = self
        detailsView.collectionView?.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = vm.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareBtn))
        view.addSubview(detailsView)
        addConstraints()
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

// MARK: - CollectionView
extension RMCharacterDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vm.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = vm.sections[section]
        
        switch sectionType {
        case .photo:
            return 1
        case .information(let vms):
            return vms.count
        case .episodes(let vms):
            return vms.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = vm.sections[indexPath.section]
        
        switch sectionType {
        case .photo(let vm):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier,
                for: indexPath
            ) as? RMCharacterPhotoCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: vm)
            return cell
        case .information(let vms):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier,
                for: indexPath
            ) as? RMCharacterInfoCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: vms[indexPath.row])
            return cell
        case .episodes(let vms):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier,
                for: indexPath
            ) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError("Unsupported cell")
            }
            cell.configure(with: vms[indexPath.row])
            return cell
        }
    }
    
    
}

extension RMCharacterDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = vm.sections[indexPath.section]
        
        switch sectionType {
        case .photo, .information:
            break
        case .episodes(_):
            let episodes = self.vm.episodes
            let selection = episodes[indexPath.row]
            let vc = RMEpisodeDetailsViewController(url: URL(string: selection))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

