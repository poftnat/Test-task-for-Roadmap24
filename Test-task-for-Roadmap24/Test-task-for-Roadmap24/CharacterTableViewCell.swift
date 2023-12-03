//
//  CharacterTableViewCell.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 26.11.2023.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    
    private lazy var informationTypeTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto", size: 16)
        label.textColor = UIColor(red: 0.03, green: 0.12, blue: 0.20, alpha: 1.00)
        return label
    }()
    
    private lazy var informationTextLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto", size: 14)
        label.textColor = UIColor(red: 0.43, green: 0.47, blue: 0.55, alpha: 1.00)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        [informationTypeTextLabel, informationTextLabel].forEach {
            ($0).translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            informationTypeTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            informationTypeTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            informationTypeTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            informationTextLabel.topAnchor.constraint(equalTo: informationTypeTextLabel.bottomAnchor, constant: 4),
            informationTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            informationTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(data: PairProperties) {
        let localHelper = data.property
        if localHelper == "" {
            informationTextLabel.text = "unknown"
        } else {
            informationTextLabel.text = data.property
        }
        informationTypeTextLabel.text = data.propertyType
    }
}
