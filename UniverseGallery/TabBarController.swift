//
//  TabBarController.swift
//  UniverseGalleryApp
//
//  Created by Kumar, Sawant on 09/09/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    var tabViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupVCs()
    }
    
    func setupVCs() {
            viewControllers = tabViewControllers
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            navController.navigationBar.prefersLargeTitles = true
            rootViewController.navigationItem.title = title
            return navController
        }
}
