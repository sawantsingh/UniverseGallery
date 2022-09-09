//
//  FeedLoader.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}
 
public protocol FeedLoader {
    func load(with startDate: String, endDate: String, completion: @escaping (LoadFeedResult)-> Void)
}
