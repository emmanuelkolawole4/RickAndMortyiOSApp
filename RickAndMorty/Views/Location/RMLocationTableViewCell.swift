//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by ULU on 12/05/2023.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell {

    static let identifier = String(describing: RMLocationTableViewCell.self)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dimensionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(nameLabel, typeLabel, dimensionLabel)
        accessoryType = .disclosureIndicator
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
        
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            typeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            dimensionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            dimensionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dimensionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            dimensionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
        dimensionLabel.text = nil
    }
    
    func configure(with vm: RMLocationTableViewCellViewModel) {
        nameLabel.text = vm.name
        typeLabel.text = vm.type
        dimensionLabel.text = vm.dimension
    }

}
