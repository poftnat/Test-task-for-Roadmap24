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
    
    private var renderedEpisode: [RenderedEpisode] = []
    
    private var filteredEpisodes: [RenderedEpisode] = []
    
    private let networkManager = NetworkManager()
    
    private var searchActive: Bool = false
    
    private var collectionView: UICollectionView!
    private var collectionLayout: UICollectionViewFlowLayout!
    
    private var cartoonLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PngItem_438051 3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = true
        searchBar.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 8
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Name or episode (ex.S01E01)..."
        return searchBar
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.89, green: 0.95, blue: 0.99, alpha: 1.00)
        button.setTitle("ADVANCED FILTERS", for: .normal)
        button.setTitleColor(UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), for: .normal)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        let filter = UIImageView()
        filter.image = UIImage(named: "filter_list_24px")
        filter.frame = CGRect(x: 20, y: 20, width: 18.59*1.3, height: 12*1.3)
        button.addSubview(filter)
        button.layer.shadowRadius = 1
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 1.2, height: 1.2)
        button.layer.shadowOpacity = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func loadEpisodes() {
        networkManager.loadEpisodes { [weak self] result in
            guard let self = self else { return }
            self.episodes = result
            result.forEach { episode in
                self.networkManager.loadCharacter(url: episode.characters.randomElement() ?? "") { personage in
                    self.renderedEpisode.append(RenderedEpisode(id: episode.id, name: episode.name, airDate: episode.airDate, episode: episode.episode, character: personage, url: episode.url, created: episode.created, isFavourite: false))
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        self.renderedEpisode.sort{ $0.id < $1.id }
                    }
                }
            }
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(cartoonLogoImageView)
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        
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
            
            searchBar.topAnchor.constraint(equalTo: cartoonLogoImageView.bottomAnchor, constant: 50),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 21),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -21),
            searchBar.heightAnchor.constraint(equalToConstant: 56),
            
            filterButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 21),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -21),
            filterButton.heightAnchor.constraint(equalToConstant: 56),
            
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCollectionViewCell")
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = .init(width: 350, height: 357)
        return layout
    }
}

//MARK: Mandatory UICollectionView protocols

extension EpisodesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filteredEpisodes.count
        } else {
            return renderedEpisode.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCollectionViewCell", for: indexPath) as? EpisodeCollectionViewCell else { return UICollectionViewCell() }
        if searchActive {
            cell.configure(episode: filteredEpisodes[indexPath.row], moveDelegate: self, reloadDelegate: nil)
        } else{
            cell.configure(episode: renderedEpisode[indexPath.row], moveDelegate: self, reloadDelegate: nil)
        }
        return cell
    }
}

//MARK: Custom delegates

extension EpisodesViewController: OpenCharacterScreenDelegate {
    func openCharacterScreen(personage: Personages) {
        let charVC = CharacterViewController(inputPersonageData: personage)
        navigationController?.pushViewController(charVC, animated: true)
    }
}

// MARK: Searchbar extension

extension EpisodesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            filteredEpisodes = renderedEpisode
            collectionView.reloadData()
        } else {
            filteredEpisodes = renderedEpisode.filter({ (item) -> Bool in
                return (item.episode.localizedCaseInsensitiveContains(searchBar.text?.lowercased() ?? ""))
            })
        }
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.showsCancelButton = true
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.searchTextField.text = ""
        self.filteredEpisodes = []
        searchActive = false
        self.searchBar.showsCancelButton = false
        self.searchBar.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }
}



