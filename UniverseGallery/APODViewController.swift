//
//  APODViewController.swift
//  UniverseGalleryApp
//
//  Created by Kumar, Sawant on 09/09/22.
//

import UIKit
import ImageryFeed

class APODViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var addToFavorite: UIBarButtonItem!
    
    @IBOutlet weak var datePickerContainer: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    // MARK: Properties
    var onSelection: () -> Void = {  }
    
    var loader: FeedLoader?
    var imageloader: ImageDataLoader?
    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // "Date must be between Jun 16, 1995 and current date";
        // Set Date picker minimum date and maximum date
        let todayDate = Date.now
        datePicker.maximumDate = todayDate
        
        let dateFormatter = DateFormatterHelper()
        let todayDateInString = dateFormatter.parseToString(date: todayDate)
        load(with: todayDateInString)
    }
    
    // MARK: IBActions
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let formatter = DateFormatterHelper()
        let dateString = formatter.parseToString(date: sender.date)
        
        load(with: dateString)
        
        datePickerContainer.isHidden = !datePickerContainer.isHidden
    }
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        datePickerContainer.isHidden = !datePickerContainer.isHidden
    }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        if var favoriteItems = UserDefaults.standard.value(forKey: "FavoriteListStoreKey") as? [String] {
            if let text = imageDateLabel.text, text.count > 0 {
                if !favoriteItems.contains(text) {
                    favoriteItems.append(text)
                    UserDefaults.standard.setValue(favoriteItems, forKey: "FavoriteListStoreKey")
                }
            }
        } else {
            if let text = imageDateLabel.text, text.count > 0 {
                UserDefaults.standard.setValue([text], forKey: "FavoriteListStoreKey")
            }
        }
        showAddToFavorite(show: false)
    }
    
    // MARK: Private Methods
    private func showAddToFavorite(show: Bool) {
        DispatchQueue.main.async {
            self.addToFavorite.isEnabled = show
            self.addToFavorite.tintColor = show ? UIColor.systemBlue : UIColor.clear
        }
    }
    
    private func showActivityIndicator(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            self.activityIndicator.isHidden = !show
        }
    }
    
    private func load(with date: String) {
        showActivityIndicator(show: true)
        
        loader?.load(with: date, endDate: date, completion: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let feedImages):
                guard let feedImage = feedImages.first else { return }
                
                self.loadImage(from: feedImage.url)
                
                if let favoriteItems = UserDefaults.standard.value(forKey: "FavoriteListStoreKey") as? [String] {
                    self.showAddToFavorite(show: !favoriteItems.contains(feedImage.date))
                }
                
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
                self.showActivityIndicator(show: false)

                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.imageView.image = image
                    }
                    return
                }
            case .failure:
                self.loadImageFromRemote(url: url, store: store, storeURL: imageStoreUrl)
            }
            
        }
    }
    
    private func loadImageFromRemote(url: URL, store: CodableImageDataStore, storeURL: URL) {
        imageloader?.load(from: url, completion: { [weak self] result in
            guard let self = self else { return }
            self.showActivityIndicator(show: false)

            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    
                    store.insert(data, url: storeURL) { _ in }
                    
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            case .failure(let error):
                print("Error is \(error)") // Replace with error logs
            }
        })
    }
}
