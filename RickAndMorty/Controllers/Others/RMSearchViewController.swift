//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by ULU on 27/04/2023.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    
    /// Config for search session
    struct SearchConfig {
        
        enum `Type` {
            case character
            case episode
            case location
            
            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Episodes"
                case .location:
                    return "Search Locations"
                }
            }
        }
        
        let type: Type
    }
    
    private let config: SearchConfig
    
    init(config: SearchConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = config.type.title
        view.backgroundColor = .systemBackground
    }
}
