//
//  RMApiCacheManager.swift
//  RickAndMorty
//
//  Created by ULU on 26/04/2023.
//

import Foundation

/// Manages in-memory session scoped API caches
final class RMApiCacheManager {
    
    private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    init() {
        constructCaches()
    }
    
    private func constructCaches() {
        RMEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
    
    func getCacheResponse(for endpoint: RMEndpoint, with url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    func setCacheResponse(for endpoint: RMEndpoint, with url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
}
