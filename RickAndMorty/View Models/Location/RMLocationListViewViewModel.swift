//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 12/05/2023.
//

import Foundation

protocol RMLocationListViewViewModelDelegate: AnyObject {
    func didLoadInitialLocations()
    func didLoadMoreLocations(with indexPaths: [IndexPath])
}

final class RMLocationListViewViewModel {
    
    weak var delegate: RMLocationListViewViewModelDelegate?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let vm = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(vm) {
                    cellViewModels.append(vm)
                }
            }
        }
    }
    
    private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    private var apiInfo: RMGetAllLocationsResponse.Info? = nil
    private var isLoadingMoreLocations = false
    
    var shouldShowLoadMoreIndicator: Bool {
        apiInfo?.next != nil
    }
    
    func getLocations() {
        RMService.shared.execute(.listLocationsRequest, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.locations = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialLocations()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func location(at idx: Int) -> RMLocation? {
        guard idx < locations.count, idx >= 0 else { return nil }
        return locations[idx]
    }
}
