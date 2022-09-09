//
//  SceneDelegate.swift
//  UniverseGallery
//
//  Created by Kumar, Sawant on 08/09/22.
//

import UIKit
import ImageryFeed

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var baseURL = URL(string: "https://api.nasa.gov/planetary/apod?api_key=jtZGOkf8hIW0k7pOVheaJvzSb1L9IkbaDW40sfLE")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private var storeURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private lazy var store: FeedStore = {
        return  CodableFeedStore(
            storeURL: storeURL)
    }()
    
    private lazy var localFeedLoader: FeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init())
    }()
    
    private lazy var remoteFeedLoader: FeedLoader = {
        RemoteFeedLoader(url: baseURL, client: httpClient)
    }()
    
    private lazy var localToRemoteFallback: FeedLoader = {
        LocalToRemoteFallback(local: localFeedLoader, remote: remoteFeedLoader)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
    
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let tabBar = TabBarController()
        
        let APODViewController = APODUIComposer.composedWith(feedLoader: localToRemoteFallback, imageDataLoader: RemoteImageDataLoader(client: httpClient))
        
        tabBar.viewControllers = [APODViewController, FavoriteUIComposer.composedWith()]
        window?.rootViewController = tabBar
        
        window?.makeKeyAndVisible()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }
}

