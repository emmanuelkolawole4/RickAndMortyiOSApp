//
//  RMImageManager.swift
//  RickAndMorty
//
//  Created by ULU on 21/04/2023.
//

import Foundation

final class ImageManager {
    
    static let shared = ImageManager()
    private var imageDataCache = NSCache<NSString, NSData >()
    
    private init() {}
    
    /// Download image content from url
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: Callback
    func downloadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            
            completion(.success(data))
        }
        task.resume()
    }
}
