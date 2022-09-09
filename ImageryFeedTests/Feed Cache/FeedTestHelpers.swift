//
//  FeedTestHelpers.swift
//  ImageryFeedTests
//
//  Created by Kumar, Sawant on 08/09/22.
//

import XCTest

func anyNSError() -> NSError {
    NSError(domain: "Any-Error", code: 1, userInfo: nil)
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}
