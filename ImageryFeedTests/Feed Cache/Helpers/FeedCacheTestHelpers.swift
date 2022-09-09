//
//  FeedCacheTestHelpers.swift
//  ImageryFeedTests
//
//  Created by Kumar, Sawant on 08/09/22.
//

import XCTest
import ImageryFeed

extension XCTestCase {
    
    func uniqueImageFeed() -> (models: [FeedImage], locals: [LocalFeedImage]) {
        let models = [uniqueImage(), uniqueImage()]
        let localFeedItems = models.map { LocalFeedImage(date: $0.date, title: $0.title, explanation: $0.explanation, url: $0.url, hdurl: $0.hdurl) }
        
        return (models, localFeedItems)
    }
    
    func uniqueImage() -> FeedImage {
        FeedImage(date: "2022-09-08", title: "a-title", explanation: "an-explanation", url: anyURL(), hdurl: anyURL())
    }
    
}

extension Date {
    
    func minusFeedCacheMaxDays() -> Date {
        adding(days: -feedCachemMaxAge)
    }
    
    private var feedCachemMaxAge: Int {
        7
    }
    
    func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date{
    func adding(seconds: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .second, value: seconds, to: self)!
    }
}

