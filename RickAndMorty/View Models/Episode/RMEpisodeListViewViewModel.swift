//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by ULU on 27/04/2023.
//

import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with indexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
    
}

/// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject {
    
    weak var delegate: RMEpisodeListViewViewModelDelegate?
    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemMint,
        .systemIndigo
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let vm = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                if !cellViewModels.contains(vm) {
                    cellViewModels.append(vm)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    private var isLoadingMoreEpisodes = false
    
    var shouldShowLoadMoreIndicator: Bool {
        apiInfo?.next != nil
    }
    
    /// Fetch initial set of episodes(20)
    func getEpisodes() {
        RMService.shared.execute(.listEpisodesRequest, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func getMoreEpisodes(from url: URL) {
        guard !isLoadingMoreEpisodes else {
            return
        }
        
        isLoadingMoreEpisodes = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            print("failed to create request")
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                let originalCount = self.episodes.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIdxForInsertOperation = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIdxForInsertOperation..<(startingIdxForInsertOperation + newCount))
                    .compactMap { IndexPath(row: $0, section: 0)}
                
                self.apiInfo = info
                self.episodes.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                    self.isLoadingMoreEpisodes = false
                }
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreEpisodes = false
            }
        }
    }
}

// MARK: - CollectionView
extension RMEpisodeListViewViewModel : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
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

extension RMEpisodeListViewViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentScreenBounds =  collectionView.bounds // collectionView.window?.windowScene?.screen.bounds
        let margins = (left: 10, right: 10)
        let cellWidth = (currentScreenBounds.width - CGFloat((margins.left + margins.right)))
        return CGSize(width: cellWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}

extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // some calculation to show that we're already at the bottom of the scrollview
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
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
                self?.getMoreEpisodes(from: url)
            }
            
            t.invalidate()
        }
        
    }
}

