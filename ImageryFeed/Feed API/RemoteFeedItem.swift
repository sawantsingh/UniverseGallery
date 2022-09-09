//
//  RemoteFeedItem.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let date: String
    internal let title: String
    internal let explanation: String?
    internal let url: URL
    internal let hdurl: URL
}
