//
//  LocalFeedImage.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 09/09/22.
//

import Foundation

public struct LocalFeedImage: Equatable {
    public let date: String
    public let title: String
    public let explanation: String?
    public let url: URL
    public let hdurl: URL
    
    public init(date: String, title: String, explanation: String?, url: URL, hdurl: URL) {
        self.date = date
        self.title = title
        self.explanation = explanation
        self.url = url
        self.hdurl = hdurl
    }
}
