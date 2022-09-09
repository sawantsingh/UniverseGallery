//
//  FeedItemsMapper.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation

internal final class FeedItemsMapper {
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
#if DEBUG
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(jsonData)
        } catch {
            print(error)
        }
#endif
        
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode([RemoteFeedItem].self, from: data) else {
                  throw RemoteFeedLoader.Error.invalidData
              }
        return root
    }
}
