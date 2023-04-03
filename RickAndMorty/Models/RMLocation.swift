//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import Foundation

struct RMLocation: Decodable {
    let id: Int
    let residents: [String]
    let name, url, type, dimension, created: String
}
