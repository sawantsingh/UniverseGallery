//
//  APODViewController.swift
//  UniverseGalleryApp
//
//  Created by Kumar, Sawant on 09/09/22.
//

import UIKit
import ImageryFeed

class APODViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var datePickerContainer: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!

    var onSelection: () -> Void = {  }
    
    var loader: FeedLoader?
    var imageloader: ImageDataLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // "Date must be between Jun 16, 1995 and current date";
        // Set Date picker minimum date and maximum date
        datePicker.maximumDate = Date.now
        load(with: "2022-09-08")
    }
        
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        print(sender.date)

        let formatter = DateFormatterHelper()
        
        let dateString = formatter.parseToString(date: sender.date)
        
        print(dateString)
        load(with: dateString)
                
        datePickerContainer.isHidden = !datePickerContainer.isHidden
    }
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        datePickerContainer.isHidden = !datePickerContainer.isHidden
    }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        if var favoriteItems = UserDefaults.standard.value(forKey: "FavoriteListStoreKey") as? [String] {
            if let text = imageDateLabel.text, text.count > 0 {
                favoriteItems.append(text)
            }
        } else {
            if let text = imageDateLabel.text, text.count > 0 {
                UserDefaults.standard.setValue([text], forKey: "FavoriteListStoreKey")
            }
        }
    }
    
    private func load(with date: String) {
        loader?.load(with: date, endDate: date, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let feedImages):
                guard let feedImage = feedImages.first else { return }
                
                self.loadImage(from: feedImage.url)
                
                DispatchQueue.main.async {
                    self.imageDateLabel.text = feedImage.date
                    self.titleLabel.text = feedImage.title
                    self.explanationLabel.text = feedImage.explanation
                }
            case .failure(let error):
                print("Error is \(error)")
            }
        })
    }
    
    private func loadImage(from url: URL) {
        
        let lastPathComponent = url.lastPathComponent
        let fileName = lastPathComponent.components(separatedBy: ".").first
        
        let imageStoreUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(fileName ?? "")")
        
        let store = CodableImageDataStore(storeURL: imageStoreUrl)
        
        store.retrieve(from: imageStoreUrl) { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.imageView.image = image
                    }
                    return
                }
            case let .failure(error):
                self.loadImageFromRemote(url: url, store: store, storeURL: imageStoreUrl)
            }
        }
        
        
    }
    
    func loadImageFromRemote(url: URL, store: CodableImageDataStore, storeURL: URL) {
        imageloader?.load(from: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    
                    store.insert(data, url: storeURL) { result in
                        // do nothing
                    }
                    
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            case .failure(let error):
                print("Error is \(error)")
            }
        })
    }
    
    func enrich(_ storeUrl: URL, with url: URL) -> URL {
        let lastPathComponent = url.lastPathComponent
        let fileName = lastPathComponent.components(separatedBy: ".").first
        return storeUrl.appendingPathComponent("images/\(fileName)")
    }
}
