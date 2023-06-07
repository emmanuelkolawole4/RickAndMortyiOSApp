//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 05/05/2023.
//

import UIKit

typealias TapHandler = (RMSettingsOption) -> Void

struct RMSettingsCellViewModel: Identifiable {
    
    let id = UUID()
    let tapHandler: TapHandler
    let option: RMSettingsOption
    
    var image: UIImage? {
        return option.iconImage
    }
    
    var title: String {
        return option.displayTitle
    }
    
    var iconContainerColor: UIColor {
        return option.iconContainerColor
    }
    
    init(option: RMSettingsOption, tapHandler: @escaping TapHandler) {
        self.option = option
        self.tapHandler = tapHandler
    }
}
