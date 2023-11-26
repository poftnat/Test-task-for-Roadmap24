//
//  EpisodeCollectionViewCell.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedImage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var nameTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Place name here"
        return label
    }()
    
    private lazy var episodeFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var playImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MonitorPlay")
        return imageView
    }()
    
    private lazy var episodeTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Inter", size: 16)
        label.textColor = UIColor(red: 0.19, green: 0.20, blue: 0.20, alpha: 1.00)
        return label
    }()
    
    var likeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        let image = UIImage(named: "Heart")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setBackgroundImage(image, for: .normal)
        button.isUserInteractionEnabled = true
        let tap = UIGestureRecognizer()
        button.addGestureRecognizer(tap)
        button.addTarget(self, action: #selector(tappedMe(sender:)), for: .touchUpInside)
        //        button.isHighlighted = true
        return button
    }()
    
    weak var openCharacterScreenDelegate: OpenCharacterScreenDelegate? // свойство типа делегата (хз что это такое, не переменная )
    
    private var personage: Personages?
    
    
    private func setupCell() {
        [characterImageView, nameTextLabel, episodeFieldView, playImageView, episodeTextLabel, likeButton].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 232),
            //            characterImageView.widthAnchor.constraint(equalToConstant: 311),
            
            nameTextLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            nameTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameTextLabel.heightAnchor.constraint(equalToConstant: 54),
            
            episodeFieldView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            episodeFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            episodeFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            episodeFieldView.heightAnchor.constraint(equalToConstant: 71),
            
            playImageView.topAnchor.constraint(equalTo: episodeFieldView.topAnchor, constant: 21.92),
            playImageView.leadingAnchor.constraint(equalTo: episodeFieldView.leadingAnchor, constant: 21.92),
            playImageView.heightAnchor.constraint(equalToConstant: 34.08),
            playImageView.widthAnchor.constraint(equalToConstant: 32.88),
            
            episodeTextLabel.leadingAnchor.constraint(equalTo: episodeFieldView.leadingAnchor,constant: 65.76),
            episodeTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 314.4),
            episodeTextLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -4),
            
            likeButton.centerYAnchor.constraint(equalTo: episodeFieldView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: episodeFieldView.trailingAnchor, constant: -25),
            likeButton.widthAnchor.constraint(equalToConstant: 41),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configure(episode: Episodes, personage: Personages, delegate: OpenCharacterScreenDelegate) {
        setupCell()
        setupConstraints()
        
        episodeTextLabel.text = "\(episode.name) | \(episode.episode)"
        openCharacterScreenDelegate = delegate
        nameTextLabel.text = personage.name
        self.personage = personage
        
        guard let imageURL = URL(string: personage.image ?? "") else { return }
        characterImageView.load(url: imageURL)
        
    }
    
    @objc func tappedMe(sender: UIButton) {
        likeButton.tintColor = .red
        rotateView(targetView: likeButton, duration: 1)
        
        
        //        likeButton.isHighlighted.toggle()
        //        switch likeButton.isHighlighted {
        //        case true:
        //            likeButton.tintColor = .systemMint
        //            likeButton.isHighlighted = false
        //
        //        case false:
        //            likeButton.tintColor = .green
        //            likeButton.isHighlighted = true
        //        }
        
    }
    
    @objc func tappedImage(sender: UITapGestureRecognizer) {
        guard let personage = personage else { return }
        openCharacterScreenDelegate?.openCharacterScreen(personage: personage)
        
    }
    
    private func rotateView(targetView: UIView, duration: Double) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.scaledBy(x: 100, y: 100)
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }
    
}
