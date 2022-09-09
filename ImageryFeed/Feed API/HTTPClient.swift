//
//  HTTPClient.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
