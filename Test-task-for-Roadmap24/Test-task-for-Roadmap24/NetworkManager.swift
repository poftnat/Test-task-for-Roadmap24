//
//  NetworkManager.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.
//

import Foundation

final class NetworkManager {
    
    func loadEpisodes(completion: @escaping ([Episodes]) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let data = data {
                do {
                    let episodes = try JSONDecoder().decode(EpisodesData.self, from: data)
                    completion(episodes.episodes)
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func loadCharacter(url: String, completion: @escaping (Personages) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let data = data {
                do {
                    let personages = try JSONDecoder().decode(Personages.self, from: data)
                    completion(personages)
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
