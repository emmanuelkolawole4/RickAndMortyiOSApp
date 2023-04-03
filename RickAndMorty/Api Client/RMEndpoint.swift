//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import Foundation

/// Represents unique API endpoints
@frozen enum RMEndpoint: String {
    /// Endpoint to get character info
    case character // "character"
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
