//
//  EpisodesSource.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.
//

import Foundation

struct EpisodesData: Decodable {
    let episodes: [Episodes]
    
    private enum CodingKeys: String, CodingKey {
        case episodes = "results"
    }
    
    init(episodes: [Episodes]) {
        self.episodes = episodes
    }
}
    
struct Episodes: Decodable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String
    
    var oneCharacter: String {
        return characters.randomElement() ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
    
    
}

