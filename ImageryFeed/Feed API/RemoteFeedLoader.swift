//
//  RemoteFeedLoader.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let requestedURL: URL
    private let client: HTTPClient
        
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    public init(url: URL, client: HTTPClient) {
        self.requestedURL = url
        self.client = client
    }
    
    public func load(with startDate: String, endDate: String, completion: @escaping (Result) -> Void) {
        let url = enrich(requestedURL, with: startDate, endDate: endDate)
        
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data: data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    static func map(data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension RemoteFeedLoader {
    func enrich(_ url: URL, with startDate: String, endDate: String) -> URL {
        return url.appending("start_date", value: startDate)
            .appending("end_date", value: endDate)
    }
}

extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        return map { FeedImage(date: $0.date, title: $0.title, explanation: $0.explanation, url: $0.url, hdurl: $0.hdurl) }
    }
}


