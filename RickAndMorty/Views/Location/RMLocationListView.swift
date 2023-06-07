//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by ULU on 12/05/2023.
//

import UIKit

protocol RMLocationListViewDelegate: AnyObject {
    func rmLocationListView(_ rmLocationListView: RMLocationListView, didSelectLocation location: RMLocation)
}

final class RMLocationListView: UIView {
    
    weak var delegate: RMLocationListViewDelegate?
    
    private var vm: RMLocationListViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.reloadData()
            tableView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.isHidden = true
        table.alpha = 0
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(spinner, tableView)
        addConstraints()
        configureTableView()
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configure(with vm: RMLocationListViewViewModel) {
        self.vm = vm
    }
}

extension RMLocationListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellVMs = vm?.cellViewModels else {
            fatalError("No ViewModel")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellVMs[indexPath.row])
        return cell
    }
    
    
}

extension RMLocationListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let location = vm?.location(at: indexPath.row) else { return }
        delegate?.rmLocationListView(self, didSelectLocation: location)
    }
}
