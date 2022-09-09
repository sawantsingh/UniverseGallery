//
//  FeedImageDataMapper.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 09/09/22.
//

import Foundation

public final class FeedImageDataMapper {
    
    private static var OK_200: Int { return 200 }

    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.statusCode == OK_200, !data.isEmpty else {
            throw Error.invalidData
        }

        return data
    }
}
