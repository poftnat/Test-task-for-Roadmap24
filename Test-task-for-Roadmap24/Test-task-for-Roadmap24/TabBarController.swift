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
        
        firstNavController.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "Home"), tag: 0)
        secondNavController.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "Vector"), tag: 1)
                
        setViewControllers([firstNavController, secondNavController], animated: true)
    }
}
