//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 12/05/2023.
//

import Foundation

struct RMLocationTableViewCellViewModel: Hashable {
    
    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    var name: String {
        return location.name
    }
    
    var type: String {
        return "Type: " + location.type
    }
    
    var dimension: String {
        return location.dimension
    }
    
    // MARK: - Hashable
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue // or you can do return lhs.location.id == rhs.location.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
        hasher.combine(location.id)
    }
}
