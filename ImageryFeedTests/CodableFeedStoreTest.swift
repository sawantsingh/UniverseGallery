//
//  CodableFeedStoreTest.swift
//  ImageryFeedTests
//
//  Created by Kumar, Sawant on 08/09/22.
//

import XCTest
import ImageryFeed

class CodableFeedStoreTest: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        setUpEmptyStoreState()
    }
    
    override func setUp() {
        super.setUp()
        undoStoreSideEffects()
    }
    
    func test_retreive_deliverEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retreive_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_insert_intoEmptyCacheDeliverInsertedValue() {
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for cache retreive")
        let feed = uniqueImageFeed().locals
        let timestamp = Date()
        
        sut.insert(feed, timestamp: timestamp.description, completion: { insertionError in
            XCTAssertNil(insertionError, "Expected feed to inserted successfully")
            
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp.description))
    }
    
    func test_retreive_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for cache retreive")
        let feed = uniqueImageFeed().locals
        let timestamp = Date()
        
        sut.insert(feed, timestamp: timestamp.description, completion: { insertionError in
            XCTAssertNil(insertionError, "Expected feed to inserted successfully")
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp.description))
    }
    
    // - MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeak(sut, file: file, line:  line)
        return sut
    }
    
    private func expect(_ sut: CodableFeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: CodableFeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty):
                break
                
            case (.found(let expectedFeed, let expectedTimeStamp), .found(let retrievedFeed, let retrievedTimeStamp)):
                XCTAssertEqual(retrievedFeed, expectedFeed)
                XCTAssertEqual(retrievedTimeStamp, expectedTimeStamp)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private var storeURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func setUpEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: storeURL)
    }
    
}
