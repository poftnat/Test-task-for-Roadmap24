//
//  ViewController.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.
//

import UIKit

protocol OpenCharacterScreenDelegate: AnyObject {
    func openCharacterScreen(personage: Personages)
}

final class EpisodesViewController: UIViewController {
    
    private var episodes: [Episodes] = []
    
    private let networkManager = NetworkManager()
    
    private var collectionView: UICollectionView!
    private var collectionLayout: UICollectionViewFlowLayout!
    
    private var cartoonLogoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 24, y: 228, width: view.frame.size.width - 48, height: 56)
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = true
        searchBar.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 8
        searchBar.placeholder = "Name or episode (ex.S01E01)..."
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 21, y: 296, width: view.frame.size.width - 42, height: 56)
        button.backgroundColor = UIColor(red: 0.89, green: 0.95, blue: 0.99, alpha: 1.00)
        button.setTitle("ADVANCED FILTERS", for: .normal)
        button.setTitleColor(UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()
    
    var singleEpisode: Episodes?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadEpisodes()
        
    }
    
    private func loadEpisodes() {
        networkManager.loadEpisodes { [weak self] result in
            guard let self = self else { return }
            self.episodes = result
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
        }
    }
    
    private func setupCollectionView() {
        cartoonLogoImageView.image = UIImage(named: "PngItem_438051 3")
        view.addSubview(cartoonLogoImageView)
        cartoonLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        view.addSubview(filterButton)
        
        collectionLayout = setupFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 4
        
        
        
        NSLayoutConstraint.activate([
            cartoonLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            cartoonLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartoonLogoImageView.widthAnchor.constraint(equalToConstant: 312),
            cartoonLogoImageView.heightAnchor.constraint(equalToConstant: 104),
            
            
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.dataSource = self
//        collectionView.delegate = self
        
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCollectionViewCell")
        
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

extension EpisodesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCollectionViewCell", for: indexPath) as? EpisodeCollectionViewCell else { return UICollectionViewCell() }
        networkManager.loadCharacter(url: episodes[indexPath.row].oneCharacter) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                cell.configure(episode: self.episodes[indexPath.row], personage: result, delegate: self)
                cell.openCharacterScreenDelegate = self
            }
        }

        
        return cell
        
    }
}

extension EpisodesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
        
    }
}
extension EpisodesViewController: OpenCharacterScreenDelegate {
    func openCharacterScreen(personage: Personages) {
        let charVC = CharacterViewController(inputPersonageData: personage)
        navigationController?.pushViewController(charVC, animated: true)
    }
}

