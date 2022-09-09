//
//  LocalFeedLoader.swift
//  AudioFeed
//
//  Created by Kumar, Sawant on 02/05/22.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: Date
    
    public init(store: FeedStore, currentDate: Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Error?
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = LoadFeedResult
    
    public func load(with startDate: String, endDate: String, completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .found(feed, _):
                completion(.success(feed.toModel()))
                
            case .empty:
                completion(.success([]))
            }
        }
    }
    
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }
            case .found:
                self.store.deleteCachedFeed { _ in }
            case .empty: break
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        guard let timeStamp = feed.first?.date else { return }
        
        store.insert(feed.toLocal(), timestamp: timeStamp) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(date: $0.date, title: $0.title, explanation: $0.explanation, url: $0.url, hdurl: $0.hdurl) }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModel() -> [FeedImage] {
        return map { FeedImage(date: $0.date, title: $0.title, explanation: $0.explanation, url: $0.url, hdurl: $0.hdurl) }
    }
}
