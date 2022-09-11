//
//  FavoriteUIComposer.swift
//  UniverseGalleryApp
//
//  Created by Kumar, Sawant on 09/09/22.
//

import UIKit
import ImageryFeed

class FavoriteUIComposer {
    
    private init() {}
    
    public static func composedWith(loader: FeedLoader) -> FavoriteTableViewController {
        let controller = makeViewController(title: "Favorite")
        controller.loader = loader
        return controller
    }

    private static func makeViewController(title: String) -> FavoriteTableViewController {
        let bundle = Bundle(for: FavoriteTableViewController.self)
        let storyboard = UIStoryboard(name: "Favorite", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as! FavoriteTableViewController
        viewController.title = title
        return viewController
    }
}
