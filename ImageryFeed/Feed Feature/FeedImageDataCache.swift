//
//  FeedImageDataCache.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws 
}

