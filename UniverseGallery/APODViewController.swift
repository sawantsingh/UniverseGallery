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
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var onSelection: () -> Void = {  }
    
    var loader: FeedLoader?
    var imageloader: ImageDataLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Date Picker:
        // "Date must be between Jun 16, 1995 and Sep 09, 2022.";
        // Set Date picker minimum date and maximum date
        
        loader?.load(with: "2022-09-04", endDate: "2022-09-04", completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let feedImages):
                let feedImage = feedImages.first
                if let url = feedImage?.url {
                    self.loadImage(from: url)
                }
                
                DispatchQueue.main.async {
                    self.titleLabel.text = feedImages.first?.title
                }
            case .failure(let error):
                print("Error is \(error)")
            }
        })
    }
        
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        print(sender.date)
        
        let formatter = DateFormatterHelper()
        
        let dateString = formatter.parseToString(date: sender.date)
        
        print(dateString)
                
        datePicker.isHidden = !datePicker.isHidden
    }
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        datePicker.isHidden = !datePicker.isHidden
    }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        
    }
    
    private func loadImage(from url: URL) {
        imageloader?.load(from: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            case .failure(let error):
                print("Error is \(error)")
            }
        })
    }
}
