//
//  PersonagesSource.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 26.11.2023.
//

import Foundation

struct Personages: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
}

struct PairProperties {
    let propertyType: String
    let property: String
}
