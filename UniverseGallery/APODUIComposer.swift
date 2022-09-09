//
//  APODUIComposer.swift
//  UniverseGalleryApp
//
//  Created by Kumar, Sawant on 09/09/22.
//

import UIKit
import ImageryFeed

class APODUIComposer {
    
    private init() {}
    
    public static func composedWith(
        feedLoader: FeedLoader,
        imageDataLoader: ImageDataLoader,
        selection: @escaping (FeedImage) -> Void = { _ in }
    ) -> APODViewController {
        let controller = makeViewController(title: "Image of the day - Today")
        controller.loader = feedLoader
        controller.imageloader = imageDataLoader
        controller.onSelection = {
            
        }
        return controller
    }

    private static func makeViewController(title: String) -> APODViewController {
        let bundle = Bundle(for: APODViewController.self)
        let storyboard = UIStoryboard(name: "APOD", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as! APODViewController
        viewController.title = title
        return viewController
    }
}
