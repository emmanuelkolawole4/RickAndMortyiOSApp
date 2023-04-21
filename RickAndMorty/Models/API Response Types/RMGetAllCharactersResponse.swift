//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by ULU on 14/04/2023.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count, pages: Int
        let next, prev: String?
    }
    let info: Info
    let results: [RMCharacter]
}
