//
//  LaunchScreenViewController.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 26.11.2023.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "PngItem_438051 3")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        let loadingImageView = UIImageView()
        loadingImageView.image = UIImage(named: "Loading component")
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.layer.shadowColor = CGColor(gray: 10, alpha: 0.5)
        loadingImageView.layer.shadowOffset = .zero
        loadingImageView.layer.shadowColor = UIColor.lightGray.cgColor
        loadingImageView.layer.shadowRadius = 10
        loadingImageView.layer.shadowOpacity = 1
        view.addSubview(loadingImageView)
        rotateView(targetView: loadingImageView, duration: 3)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 97),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 104),
            logoImageView.widthAnchor.constraint(equalToConstant: 312),
            
            loadingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 347),
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.heightAnchor.constraint(equalToConstant: 200),
            loadingImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showMainViewController()
        }
    }
    
    func showMainViewController() {
        let mainViewController = TabBarController()
        UIApplication.shared.windows.first?.rootViewController = mainViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    private func rotateView(targetView: UIView, duration: Double) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: .pi)
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }
}
