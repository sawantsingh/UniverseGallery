//
//  CacheFeedUseCaseTests.swift
//  ImageryFeedTests
//
//  Created by Kumar, Sawant on 08/09/22.
//

import XCTest
import ImageryFeed

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessges, [])
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueImageFeed().models) { _ in }
        
        XCTAssertEqual(store.receivedMessges, [.deleteCachedFeed])
    }
    
    func test_save_doesNotRequestInsertionOnCacheDeletionError() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueImageFeed().models)  { _ in }
        store.completeDeletion(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessges, [.deleteCachedFeed])
    }
    
    let dateFormatter = DateFormatter()
    
    func test_save_failsOnDeletionError() {
        let deletionError = anyNSError()
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let insertionError = anyNSError()
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_successOnInsertionError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doesnNotDeliverDeletionErrorAfterSutInstanceDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date())
        
        var receivedError: Error?
        sut?.save(uniqueImageFeed().models, completion: { error in
            receivedError = error
        })
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertNil(receivedError)
    }
    
    func test_save_doesnNotDeliverInsertionErrorAfterSutInstanceDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date())
        
        var receivedError: Error?
        sut?.save(uniqueImageFeed().models , completion: { error in
            receivedError = error
        })
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        
        XCTAssertNil(receivedError)
    }
    
    // MARK: Helpers
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for save completion")
        
        var receivedError: Error?
        sut.save([uniqueImage()]) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, expectedError)
    }
    
    private func makeSUT(currentDate: Date = Date()) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return (sut, store)
    }
}


