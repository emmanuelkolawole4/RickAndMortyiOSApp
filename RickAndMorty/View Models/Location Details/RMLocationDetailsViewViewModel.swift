//
//  RMLocationDetailsViewViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 14/05/2023.
//

import Foundation

protocol RMLocationDetailsViewViewModelDelegate: AnyObject {
    func didGetLocationDetails()
}

final class RMLocationDetailsViewViewModel {
    
    private let endpointUrl: URL?
    weak var delegate: RMLocationDetailsViewViewModelDelegate?
    
    enum SectionType {
        case information(vms: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(vms: [RMCharacterCollectionViewCellViewModel])
    }
    
    private(set) var cellViewModelsSections: [SectionType] = []
    
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            setupCellViewModelsSections()
            delegate?.didGetLocationDetails()
        }
    }
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    /// get backing location model
    func getLocationData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
            switch result {
            case .success(let location):
                self?.getResidentCharacters(from: location)
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
        let location = dataTuple.location
        let characters = dataTuple.characters
        var createdDateString = location.created
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdDateString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate)
        }
        
        cellViewModelsSections = [
            .information(vms: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
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
    
    private func getResidentCharacters(from location: RMLocation) {
        let requests: [RMRequest] = location.residents
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
                location: location,
                characters: characters
            )
        }
    }
    
}
