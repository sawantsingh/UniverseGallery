//
//  FavoriteTableViewController.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 10/09/22.
//

import UIKit
import ImageryFeed

class FavoriteItemCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var favoriteImageView: UIImageView!
}

class FavoriteTableViewController: UITableViewController {
    
    var datasource: [FeedImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10 //datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteItemCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FavoriteItemCell
        
        cell.titleLabel.text = "abc \(indexPath.row)"

        return cell
    }
}
