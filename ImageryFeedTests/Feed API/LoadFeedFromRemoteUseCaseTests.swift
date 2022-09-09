//
//  LoadFeedFromRemoteUseCaseTests.swift
//  ImageryFeedTests
//
//  Created by Kumar, Sawant on 08/09/22.
//

import XCTest
import ImageryFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
   
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (_, client) = makeSUT(url: url)

        XCTAssert(client.requestedURLs.isEmpty)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
       
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0, userInfo: nil)
            client.complete(with: clientError)
        }
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemJSON([])
                client.complete(with: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(with: 200, data: invalidJSON)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasbeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: URL(string: "https://a-url.com")!, client: client)
        
        var capturedResult = [RemoteFeedLoader.Result]()
        sut?.load { capturedResult.append($0) }
        
        sut = nil
        client.complete(with: 200, data: makeItemJSON([]))
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeItem(date: String, title: String, explanation: String, url: URL, hdurl: URL) -> (model: FeedImage, json: [String : Any]) {
        let item = FeedImage(date: date, title: title, explanation: explanation, url: url, hdurl: hdurl)
        
        let json = [
            "date": date,
            "title": title,
            "explanation": explanation,
            "url": url.absoluteString,
            "hdurl": hdurl.absoluteString,
        ].reduce(into: [String: Any]()) { (acc, e) in
            acc[e.key] = e.value
        }
        
        return (item, json)
    }
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(client, file: file, line: line)

        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error:Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        
        func complete(with statusCode:Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
    }
}
 
