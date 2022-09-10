//
//  LocalToRemoteFallback.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 09/09/22.
//

import Foundation
import ImageryFeed

struct NetworkReacability {
    
    static let isReachable = true
}

final class LocalToRemoteFallback: FeedLoader {
    
    private let local: FeedLoader
    private let remote: FeedLoader
    
    init(local: FeedLoader, remote: FeedLoader) {
        self.local = local
        self.remote = remote
    }
    
    func load(with startDate: String, endDate: String, completion: @escaping (LoadFeedResult) -> Void) {
//        if !NetworkReacability.isReachable {
//            self.loadFromRemote(with: startDate, endDate: endDate, completion: completion)
//            return
//        }
        
        local.load(with: startDate, endDate: endDate, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let feed):
                let filtered = feed.filter { $0.date == startDate }
                if filtered.count > 0 {
                    completion(.success(filtered))
                } else {
                    self.loadFromRemote(with: startDate, endDate: endDate, completion: completion)
                }
            case .failure:
                self.loadFromRemote(with: startDate, endDate: endDate, completion: completion)
            }
        })
    }
    
    private func loadFromRemote(with startDate: String, endDate: String, completion: @escaping (LoadFeedResult) -> Void) {
        
        remote.load(with: startDate, endDate: endDate) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let feed):
                (self.local as? LocalFeedLoader)?.save(feed) { error in
                    if error == nil {
                        completion(.success(feed))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
