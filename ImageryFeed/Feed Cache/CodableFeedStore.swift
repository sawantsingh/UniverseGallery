//
//  CodableImageDataStore.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 09/09/22.
//

import Foundation

public class CodableImageDataStore {
    
    let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public enum Error: Swift.Error {
      case notFound
      case unknown
    }
    
    public typealias Result = ImageDataLoader.Result
    public typealias InsertionCompletion = (Error?) -> Void
    
    struct Cache: Codable {
        let imageData: Data
    }
    
    public func retrieve(from url: URL, completion: @escaping (Result) -> Void) {
        guard let data = try? Data(contentsOf: url) else {
            completion(.failure(Error.notFound))
            return
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.success(cache.imageData))
    }
    
    public func insert(_ imageData: Data, url: URL, completion: @escaping InsertionCompletion) {
        let encoder = JSONEncoder()
        
        let cache = Cache(imageData: imageData)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: url)
        completion(nil)
    }
    
}

public class CodableFeedStore: FeedStore {
   
    struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: String
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    struct CodableFeedImage: Codable {
        private let date: String
        private let title: String
        private let explanation: String?
        private let url: URL
        private let hdurl: URL
        
        init(_ image: LocalFeedImage) {
            date = image.date
            title = image.title
            explanation = image.explanation
            url = image.url
            hdurl = image.hdurl
        }
        
        var local: LocalFeedImage {
            LocalFeedImage(date: date, title: title, explanation: explanation, url: url, hdurl: hdurl)
        }
    }
    
    let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            completion(.empty)
            return
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: String, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
                
        var updatedFeed: [LocalFeedImage] = feed
        
        retrieve { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .found(newFeed, _):
                if !newFeed.contains(feed.first!) {
                    updatedFeed.append(contentsOf: newFeed)
                }
            default:
                break
            }
        }
        
        let cache = Cache(feed: updatedFeed.map(CodableFeedImage.init), timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(nil)
    }
}
