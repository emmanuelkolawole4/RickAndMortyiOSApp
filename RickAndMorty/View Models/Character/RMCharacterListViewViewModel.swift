//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 14/04/2023.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with indexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
    
}

/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    
    weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for charcter in characters {
                let vm = RMCharacterCollectionViewCellViewModel(
                    characterName: charcter.name,
                    characterStatus: charcter.status,
                    characterImageUrl: URL(string: charcter.image)
                )
                if !cellViewModels.contains(vm) {
                    cellViewModels.append(vm)                    
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    private var isLoadingMoreCharacters = false
    
    var shouldShowLoadMoreIndicator: Bool {
        apiInfo?.next != nil
    }
    
    /// Fetch initial set of characters(20)
    func getCharacters() {
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func getMoreCharacters(from url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        
        isLoadingMoreCharacters = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("failed to create request")
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                let originalCount = self.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIdxForInsertOperation = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIdxForInsertOperation..<(startingIdxForInsertOperation + newCount))
                    .compactMap { IndexPath(row: $0, section: 0)}
                
                self.apiInfo = info
                self.characters.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                    self.isLoadingMoreCharacters = false
                }
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreCharacters = false
            }
        }
    }
}

// MARK: - CollectionView
extension RMCharacterListViewViewModel : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        
        let vm = cellViewModels[indexPath.row]
        cell.configure(with: vm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                    for: indexPath
                ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
            
        }
        footer.startLoading()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}

extension RMCharacterListViewViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentScreenBounds =  UIScreen.main.bounds // collectionView.window?.windowScene?.screen.bounds
        let margins = (left: 10, center: 10, right: 10)
        let cellWidth = (currentScreenBounds.width - CGFloat((margins.left + margins.center + margins.right))) / 2
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // some calculation to show that we're already at the bottom of the scrollview
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let urlString = apiInfo?.next,
              let url = URL(string: urlString) else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let verticalOffset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height // because the content is actually inside the scrollview, it's larger than the actual visual we see
            let totalScrollViewHeight = scrollView.frame.size.height
            
            if verticalOffset >= (totalContentHeight - totalScrollViewHeight - 120) { // 120 is a buffer for the size of the footer (which is 100)
                self?.getMoreCharacters(from: url)
            }
            
            t.invalidate()
        }
        
    }
}
