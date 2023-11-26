//
//  ImagesExtension.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
