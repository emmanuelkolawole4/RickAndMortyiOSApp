//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by ULU on 27/04/2023.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count, pages: Int
        let next, prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
