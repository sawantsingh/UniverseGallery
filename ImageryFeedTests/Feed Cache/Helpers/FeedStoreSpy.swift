//
//  FeedStoreSpy.swift
//  ImageryFeedTests
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation
import ImageryFeed

class FeedStoreSpy: FeedStore {
    
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void
    
    enum ReceivedMessages: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], String)
        case retrieve
    }
    
    private(set) var receivedMessges = [ReceivedMessages]()
    
    private var delectionCompletion = [DeletionCompletion]()
    private var insertionCompletion = [InsertionCompletion]()
    private var retrievalCompletion = [RetrievalCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        delectionCompletion.append(completion)
        receivedMessges.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        delectionCompletion[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        delectionCompletion[index](nil)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletion[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletion[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: String, completion: @escaping InsertionCompletion) {
        receivedMessges.append(.insert(feed, timestamp))
        insertionCompletion.append(completion)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletion.append(completion)
        receivedMessges.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletion[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletion[index](.empty)
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: String, index: Int = 0) {
        retrievalCompletion[index](.found(feed: feed, timestamp: timestamp))
    }
}
