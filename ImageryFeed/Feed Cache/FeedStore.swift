//
//  FeedStore.swift
//  AudioFeed
//
//  Created by Kumar, Sawant on 02/05/22.
//

import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: String)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: String, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}


