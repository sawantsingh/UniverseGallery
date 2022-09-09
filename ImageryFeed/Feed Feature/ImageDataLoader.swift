//
//  ImageDataLoader.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation
 
public protocol ImageDataLoader {
  typealias Result = Swift.Result<Data, Error>

  func load(from imageURL: URL, completion: @escaping (Result) -> Void)
}

