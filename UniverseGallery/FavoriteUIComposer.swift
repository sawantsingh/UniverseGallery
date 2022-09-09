//
//  FavoriteUIComposer.swift
//  UniverseGalleryApp
//
//  Created by Kumar, Sawant on 09/09/22.
//

import UIKit

class FavoriteUIComposer {
    
    private init() {}
    
    public static func composedWith() -> FavoriteViewController {
        let controller = makeViewController(title: "Favorite")
        return controller
    }

    private static func makeViewController(title: String) -> FavoriteViewController {
        let bundle = Bundle(for: FavoriteViewController.self)
        let storyboard = UIStoryboard(name: "Favorite", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as! FavoriteViewController
        viewController.title = title
        return viewController
    }
}
