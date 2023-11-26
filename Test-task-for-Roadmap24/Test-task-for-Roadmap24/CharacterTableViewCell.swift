//
//  CharacterTableViewCell.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 26.11.2023.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    private lazy var informationTypeTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto", size: 20)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var informationTextLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto", size: 20)
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
            informationTypeTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            informationTypeTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            informationTypeTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            
            informationTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            informationTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            informationTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
    
    func configure(data: PairProperties) {
        informationTextLabel.text = data.property
        informationTypeTextLabel.text = data.propertyType
    }
}
