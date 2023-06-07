//
//  RMGetAllLocationsResponse.swift
//  RickAndMorty
//
//  Created by ULU on 12/05/2023.
//

import Foundation

struct RMGetAllLocationsResponse: Codable {
    struct Info: Codable {
        let count, pages: Int
        let next, prev: String?
    }
    
    let info: Info
    let results: [RMLocation]
}
