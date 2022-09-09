//
//  CodableFeedStore.swift
//  AudioFeed
//
//  Created by Kumar, Sawant on 04/07/22.
//

import Foundation

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
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(nil)
    }
}
