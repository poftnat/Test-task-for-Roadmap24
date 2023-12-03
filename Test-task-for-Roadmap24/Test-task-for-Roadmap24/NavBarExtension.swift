//
//  NavBarExtension.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 29.11.2023.
//

import UIKit

extension CharacterViewController {
    
    func createCustomNavBar() {
        
        let backgroundView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: -1, y: 46, width: 387, height: 60)
            view.layer.shadowOffset = CGSize(width: 1, height: 1)
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowRadius = 2
            view.layer.shadowOpacity = 1
            view.backgroundColor = .white
            return view
        }()
        
        view.addSubview(backgroundView)
        
        let logoButton: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "logo-black 1")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.isUserInteractionEnabled = false
            let backBarItem = UIBarButtonItem(customView: button)
            return backBarItem
        }()
        
        navigationItem.rightBarButtonItem = logoButton
        
        let backButton: UIBarButtonItem = {
            let button = UIButton()
            button.setImage(UIImage(named: "Group 4")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            let backItem = UIBarButtonItem(customView: button)
            return backItem
        }()
        
        navigationItem.leftBarButtonItem = backButton
    }
}
