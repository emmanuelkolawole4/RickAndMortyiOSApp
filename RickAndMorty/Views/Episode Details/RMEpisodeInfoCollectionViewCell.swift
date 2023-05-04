//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by ULU on 28/04/2023.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: RMEpisodeInfoCollectionViewCell.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(titleLabel, valueLabel)
        setupLayer()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47)
        ])
    }
    
    private func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
        contentView.layer.borderWidth = 1
    }
    
    func configure(with vm: RMEpisodeInfoCollectionViewCellViewModel) {
        titleLabel.text = vm.title
        valueLabel.text = vm.value
    }
}
