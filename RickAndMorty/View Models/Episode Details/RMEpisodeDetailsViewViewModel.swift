//
//  RMEpisodeDetailsViewViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 27/04/2023.
//

import Foundation

protocol RMEpisodeDetailsViewViewModelDelegate: AnyObject {
    func didGetEpisdeDetails()
}

final class RMEpisodeDetailsViewViewModel {
    
    private let endpointUrl: URL?
    weak var delegate: RMEpisodeDetailsViewViewModelDelegate?
    
    enum SectionType {
        case information(vms: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(vms: [RMCharacterCollectionViewCellViewModel])
    }
    
     private(set) var cellViewModelsSections: [SectionType] = []
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            setupCellViewModelsSections()
            delegate?.didGetEpisdeDetails()
        }
    }
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
     }
    
    /// get backing episode model
    func getEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let episode):
                self?.getRelatedCharacters(in: episode)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    func character(at idx: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else { return nil }
        return dataTuple.characters[idx]
    }
    
    private func setupCellViewModelsSections() {
        guard let dataTuple = dataTuple else { return }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        var createdDateString = episode.created
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdDateString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate)
        }
        
        cellViewModelsSections = [
            .information(vms: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.airDate),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdDateString),
            ]),
            .characters(vms: characters
                .compactMap {
                    .init(
                        characterName: $0.name,
                        characterStatus: $0.status,
                        characterImageUrl: URL(string: $0.image)
                    )
                }
            )
        ]
    }
    
    private func getRelatedCharacters(in episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters
            .compactMap { URL(string: $0) }
            .compactMap { RMRequest(url: $0) }
        
        // make all API requests together in a parallel manner using dispatch group and notify once all done
        let dispatchGroup = DispatchGroup()
        var characters: [RMCharacter] = []
        
        for request in requests {
            dispatchGroup.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { [weak self] result in
                defer {
                    dispatchGroup.leave()
                }
                
                switch result {
                case .success(let character):
                    characters.append(character)
                case .failure(let failure):
                    break
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
}
