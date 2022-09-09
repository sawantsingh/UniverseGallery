//
//  ImageryFeed.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import Foundation

public struct FeedImage: Equatable {
    public let date: String
    public let title: String
    public let explanation: String?
    public let url: URL
    public let hdurl: URL
   
    public var imageData: Data?

    public init(date: String, title: String, explanation: String?, url: URL, hdurl: URL) {
        self.date = date
        self.title = title
        self.explanation = explanation
        self.url = url
        self.hdurl = hdurl
    }
    
    public init(date: String, title: String, explanation: String?, url: URL, hdurl: URL, imageData: Data) {
        self.init(date: date, title: title, explanation: explanation, url: url, hdurl: hdurl)
        
        self.imageData = imageData
    }
}
    
