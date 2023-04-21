//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import Foundation

struct RMCharacter: Codable {
    let id: Int
    let origin: RMOrigin
    let episode: [String]
    let status: RMCharacterStatus
    let gender: RMCharacterGender
    let location: RMSingleLocation
    let url, created: String
    let name, species, type, image: String
}

struct RMSingleLocation: Codable {
    let name, url: String
}

struct RMOrigin: Codable {
    let name, url: String
}

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

enum RMCharacterGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}
