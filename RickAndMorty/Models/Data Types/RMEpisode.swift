//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import Foundation

struct RMEpisode: Decodable {
    let id: Int
    let characters: [String]
    let name, url, airDate, episode, created: String
    
    enum CodingKeys: String, CodingKey {
        case id, characters, name, url, airDate = "air_date", episode, created
    }
}
