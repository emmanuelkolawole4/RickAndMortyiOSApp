//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 24/04/2023.
//

import UIKit

protocol RMEpisodeDataRendering {
    var name: String { get }
    var episode: String { get }
    var airDate: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable {
    
    let borderColor: UIColor
    private let episodeDataUrl: URL?
    private var isFetchingEpisodes = false
    private var dataBlock: ((RMEpisodeDataRendering) -> Void)?
    
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else { return }
            dataBlock?(model)
        }
    }
    
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    func getEpisode() {
        guard !isFetchingEpisodes else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        
        guard let url = episodeDataUrl,
                let request = RMRequest(url: url) else {
            return
        }
        
        isFetchingEpisodes = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.episode = response
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    func registerForData(_ block: @escaping (RMEpisodeDataRendering) -> Void) {
        self.dataBlock = block
    }
    
    // MARK: - Hashable
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(episodeDataUrl?.absoluteString ?? "")
    }
}
