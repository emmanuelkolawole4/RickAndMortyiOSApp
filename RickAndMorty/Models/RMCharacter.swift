//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import Foundation

struct RMCharacter: Decodable {
    let id: Int
    let origin: RMOrigin
    let episode: [String]
    let status: RMCharacterStatus
    let gender: RMCharacterGender
    let location: RMSingleLocation
    let url, created: String
    let name, species, type, image: String
}

struct RMSingleLocation: Decodable {
    let name, url: String
}

struct RMOrigin: Decodable {
    let name, url: String
}

enum RMCharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum RMCharacterGender: String, Decodable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}
