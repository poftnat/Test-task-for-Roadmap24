////
////  FavouritesUserDefault.swift
////  Test-task-for-Roadmap24
////
////  Created by Наталья Владимировна Пофтальная on 29.11.2023.
////
//
import Foundation

final class FavouriteEpisodes {
    static let shared = FavouriteEpisodes()
    private let userDefaults = UserDefaults.standard
    private let key = "RenderedEpisodes"
    
    func saveEpisodeIn(episode: RenderedEpisode) {
        var renderedEpisodes = getEpisodeOut()
        renderedEpisodes.append(episode)
        save(renderedEpisodes: renderedEpisodes)
    }
    
    func getEpisodeOut() -> [RenderedEpisode] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        do {
            let renderedEpisodes = try JSONDecoder().decode([RenderedEpisode].self, from: data)
            return renderedEpisodes
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save(renderedEpisodes: [RenderedEpisode]) {
        do {
            let data = try JSONEncoder().encode(renderedEpisodes)
            userDefaults.set(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeEpisode(episode: RenderedEpisode) {
        var renderedEpisodes = getEpisodeOut()
        if let index = renderedEpisodes.firstIndex(where: { $0.id == episode.id }) {
            renderedEpisodes.remove(at: index)
            save(renderedEpisodes: renderedEpisodes)
        }
    }
}


