//
//  RemoteImageDataLoader.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 09/09/22.
//

import Foundation


public final class RemoteImageDataLoader: ImageDataLoader {

      public enum Error: Swift.Error {
        case connectivity
        case invalidResponse
      }

      public typealias Result = ImageDataLoader.Result

      private let client: HTTPClient

      public init(client: HTTPClient) {
        self.client = client
      }

      public func load(from imageURL: URL, completion: @escaping (Result) -> Void) {
          client.get(from: imageURL) { [weak self] result in
              guard self != nil else { return }
              
              switch result {
              case let .success(data, _):
                  completion(.success(data))
              case .failure:
                  completion(.failure(Error.connectivity))
              }
          }
    }
}
