//
//  RMCharacterDetailsViewViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 20/04/2023.
//

import Foundation

final class RMCharacterDetailsViewViewModel {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    var title: String {
        character.name.uppercased()
    }
}
