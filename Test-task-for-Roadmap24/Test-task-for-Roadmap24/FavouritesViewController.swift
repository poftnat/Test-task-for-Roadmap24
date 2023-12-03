//
//  FavouritesViewController.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.

import UIKit

protocol ReloadCollectionDelegate: AnyObject {
    func reload()
}

final class FavouritesViewController: UIViewController {
    
    private var favouriteEpisodes: [RenderedEpisode] = []
    
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourites episodes"
        label.font = UIFont(name: "Karla-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var collectionView: UICollectionView!
    private var collectionLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(titleTextLabel)
        
        collectionLayout = setupFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 4
        
        NSLayoutConstraint.activate([
            
            titleTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleTextLabel.widthAnchor.constraint(equalToConstant: 228),
            titleTextLabel.heightAnchor.constraint(equalToConstant: 28),

            collectionView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCollectionViewCell")
        
        favouriteEpisodes = FavouriteEpisodes.shared.getEpisodeOut()
        collectionView.reloadData()
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = .init(width: 311, height: 357)
        return layout
    }
}

extension FavouritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favouriteEpisodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCollectionViewCell", for: indexPath) as? EpisodeCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(episode: favouriteEpisodes[indexPath.row], moveDelegate: self, reloadDelegate: self)
        return cell
    }
}

extension FavouritesViewController: OpenCharacterScreenDelegate {
    func openCharacterScreen(personage: Personages) {
        let charVC = CharacterViewController(inputPersonageData: personage)
        navigationController?.pushViewController(charVC, animated: true)
        collectionView.reloadData()
    }
}

extension FavouritesViewController: ReloadCollectionDelegate {
    func reload() {
        favouriteEpisodes = FavouriteEpisodes.shared.getEpisodeOut()
        collectionView.reloadData()
    }
}


