//
//  TabBarViewController.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        let episodesVC = EpisodesViewController()
        let favouritesVC = FavouritesViewController()
        
        let firstNavController = UINavigationController(rootViewController: episodesVC)
        let secondNavController = UINavigationController(rootViewController: favouritesVC)
        
//        firstNavController.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "Home"), tag: 0)
        firstNavController.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "Home-unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "Home")?.withRenderingMode(.alwaysOriginal))
        secondNavController.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "Vector")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "Vector-selected")?.withRenderingMode(.alwaysOriginal))
        setViewControllers([firstNavController, secondNavController], animated: true)
    }
}
