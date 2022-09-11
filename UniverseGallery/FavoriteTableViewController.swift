//
//  FavoriteTableViewController.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 10/09/22.
//

import UIKit
import ImageryFeed

class FavoriteTableViewController: UITableViewController {
    
    var loader: FeedLoader?
    
    var datasource: [FeedImage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var prefetchedImages: [UIImage] = []
    
    // MARK: IBOutlets
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let favoriteItems = UserDefaults.standard.value(forKey: "FavoriteListStoreKey") as? [String], favoriteItems.count > 0  else {
            // No Items found in favorite
            return
        }
        
        loader?.load(with: "", endDate: "", completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let feed):
                var filtered: [FeedImage] = []
                for feedItem in feed {
                    for favoriteItem in favoriteItems {
                        if favoriteItem == feedItem.date {
                            filtered.append(feedItem)
                        }
                    }
                }
                
                for feedItem in filtered {
                    self.loadImage(from: feedItem.url) { image in
                        if let  image = image {
                            self.prefetchedImages.append(image)
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.2))) {
                    self.datasource = filtered
                }
            case .failure: break
                // received error
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteItemCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FavoriteItemCell
        
        let favoriteItem = datasource[indexPath.row]
        
        cell.titleLabel.text = favoriteItem.title
        cell.dateLabel.text = favoriteItem.date
        cell.explanationLabel.text = favoriteItem.explanation
        
        let image = prefetchedImages[indexPath.row]
        let thumbnailImage = image.scaleToSize(aSize: CGSize(width: 150.0, height: 150.0))
        
        cell.imageView?.image = thumbnailImage
        
        return cell
    }
    
    
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let lastPathComponent = url.lastPathComponent
        let fileName = lastPathComponent.components(separatedBy: ".").first
        
        let imageStoreUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(fileName ?? "")")
        
        let store = CodableImageDataStore(storeURL: imageStoreUrl)
        
        store.retrieve(from: imageStoreUrl) { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        completion(image)
                    }
                    completion(nil)
                }
            case let .failure(error):
                completion(nil)
            }
        }
    }
}

extension UIImage {
  func scaleToSize(aSize :CGSize) -> UIImage {
      if (self.size.equalTo(aSize)) {
      return self
    }

    UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
      self.draw(in: CGRect(x: 0, y: 0, width: aSize.width, height: aSize.height))
      guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return self }
    UIGraphicsEndImageContext()
    return image
  }
}
