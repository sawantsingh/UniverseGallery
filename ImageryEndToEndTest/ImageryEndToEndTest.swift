//
//  ImageryEndToEndTest.swift
//  ImageryEndToEndTest
//
//  Created by Kumar, Sawant on 08/09/22.
//

import XCTest
import ImageryFeed

class ImageryEndToEndTest: XCTestCase {
    
    func test_endToEndTestServerGETFeedResult_matchesFixedTextAccountData() {
        switch getFeedResult() {
        case let .success(imageFeed):
            XCTAssertEqual(imageFeed.count, 1, "Expected 1 image with demo key")
            
            XCTAssertEqual(imageFeed[0], expectedImage(at: 0))
        case let .failure(error):
            XCTFail("expected images but got error \(error)")
            
        default:
            XCTFail("Expected successful feed but got no result")
        }
    }
    
    // MARK: Helpers
    
    private func getFeedResult() -> LoadFeedResult? {
        let url = URL(string: "https://api.nasa.gov/planetary/apod?start_date=2022-09-08&end_date=2022-09-08&api_key=jtZGOkf8hIW0k7pOVheaJvzSb1L9IkbaDW40sfLE")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteFeedLoader(url: url, client: client)
        
        let exp = expectation(description: "wait for load completion")
        
        var receivedResult: LoadFeedResult?
        
        loader.load { result in
            receivedResult = result
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
    
    private func expectedImage(at index: Int) -> FeedImage {
        return FeedImage(date: date(),
                         title: title(),
                         explanation: explanation(),
                         url: url(),
                         hdurl: hdurl())
    }
    
    private func date() -> String {
         "2022-09-08"
    }
    
    private func title() -> String {
         "North America and the Pelican"
    }
    
    private func explanation() -> String? {
         "Fans of our fair planet might recognize the outlines of these cosmic clouds. On the left, bright emission outlined by dark, obscuring dust lanes seems to trace a continental shape, lending the popular name North America Nebula to the emission region cataloged as NGC 7000. To the right, just off the North America Nebula's east coast, is IC 5070, whose avian profile suggests the Pelican Nebula.  The two bright nebulae are about 1,500 light-years away, part of the same large and complex star forming region, almost as nearby as the better-known Orion Nebula. At that distance, the 3 degree wide field of view would span 80 light-years. This careful cosmic portrait uses narrowband images combined to highlight the bright ionization fronts and the characteristic glow from atomic hydrogen, and oxygen gas. These nebulae can be seen with binoculars from a dark location.  Look northeast of bright star Deneb in Cygnus the Swan, soaring high in the northern summer night sky."
    }
    
    private func url() -> URL {
        URL(string: "https://apod.nasa.gov/apod/image/2209/NGC7000_NB_2022_1024.jpg")!
    }
    
    private func hdurl() -> URL {
        URL(string: "https://apod.nasa.gov/apod/image/2209/NGC7000_NB_2022_2048.jpg")!
    }
}
