//
//  EpisodeCollectionViewCell.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.

import UIKit

final class EpisodeCollectionViewCell: UICollectionViewCell {
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-black 1")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedImage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var nameTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Roboto-Regular", size: 20)
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
        label.font = UIFont(name: "Inter-Regular", size: 16)
        label.textColor = UIColor(red: 0.19, green: 0.20, blue: 0.20, alpha: 1.00)
        return label
    }()
    
    var likeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setImage(UIImage(named: "Heart"), for: .normal)
        button.addTarget(self, action: #selector(tappedLikeButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    weak var openCharacterScreenDelegate: OpenCharacterScreenDelegate?
    weak var reloadCollectionDelegate: ReloadCollectionDelegate?
    
    private var renderedEpisode: RenderedEpisode?
    
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
            
            nameTextLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor),
            nameTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameTextLabel.bottomAnchor.constraint(equalTo: episodeFieldView.topAnchor),
            
            episodeFieldView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            episodeFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            episodeFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            episodeFieldView.heightAnchor.constraint(equalToConstant: 71),
            
            playImageView.centerYAnchor.constraint(equalTo: episodeFieldView.centerYAnchor),
            playImageView.leadingAnchor.constraint(equalTo: episodeFieldView.leadingAnchor, constant: 21.92),
            playImageView.heightAnchor.constraint(equalToConstant: 34.08),
            playImageView.widthAnchor.constraint(equalToConstant: 32.88),
            
            episodeTextLabel.topAnchor.constraint(equalTo: episodeFieldView.topAnchor),
            episodeTextLabel.leadingAnchor.constraint(equalTo: episodeFieldView.leadingAnchor,constant: 65.76),
            episodeTextLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -4),
            episodeTextLabel.bottomAnchor.constraint(equalTo: episodeFieldView.bottomAnchor),
            
            likeButton.centerYAnchor.constraint(equalTo: episodeFieldView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: episodeFieldView.trailingAnchor, constant: -25),
            likeButton.widthAnchor.constraint(equalToConstant: 41),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configure(episode: RenderedEpisode, moveDelegate: OpenCharacterScreenDelegate, reloadDelegate: ReloadCollectionDelegate?) {
        
        setupCell()
        setupConstraints()
        openCharacterScreenDelegate = moveDelegate
        reloadCollectionDelegate = reloadDelegate
        renderedEpisode = episode
        episodeTextLabel.text = "\(episode.name) | \(episode.episode)"
        nameTextLabel.text = episode.character.name
        
        guard let imageURL = URL(string: episode.character.image) else { return }
        characterImageView.load(url: imageURL)
        
        if FavouriteEpisodes.shared.getEpisodeOut().contains(where: { favouriteEpisode in
            favouriteEpisode.id == episode.id
        }){
            likeButton.setImage(UIImage(named: "red heart"), for: .normal)
            renderedEpisode?.isFavourite = true
        } else {
            likeButton.setImage(UIImage(named: "Heart"), for: .normal)
            renderedEpisode?.isFavourite = false
        }
    }
    
    @objc func tappedLikeButton(sender: UIButton) {
        guard let renderedEpisode = renderedEpisode else { return }
        DispatchQueue.main.async {
            if FavouriteEpisodes.shared.getEpisodeOut().contains(where: { favouriteEpisode in
                favouriteEpisode.id == renderedEpisode.id
            }) {
                self.likeButton.setImage(UIImage(named: "Heart"), for: .normal)
                FavouriteEpisodes.shared.removeEpisode(episode: renderedEpisode)
                self.reloadCollectionDelegate?.reload()
            } else {
                self.likeButton.setImage(UIImage(named: "red heart"), for: .normal)
                FavouriteEpisodes.shared.saveEpisodeIn(episode: renderedEpisode)
                self.reloadCollectionDelegate?.reload()
            }
            self.reloadCollectionDelegate?.reload()
        }
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
            sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    @objc func tappedImage(sender: UITapGestureRecognizer) {
        guard let personage = renderedEpisode?.character else { return }
        openCharacterScreenDelegate?.openCharacterScreen(personage: personage)
    }
}


