//
//  RMService.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatized constructor
    private init() {}
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Reqeust instance
    ///   - completion: Callback with data or error
    func execute(_ request: RMRequest, completion: @escaping () -> Void) {
        
    }
}
