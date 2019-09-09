//
//  AdTableViewController.swift
//  Classifieds
//
//  Created by Lewis Jones on 10/03/2019.
//  Copyright © 2019 Rodrigo. All rights reserved.
//

import UIKit

class AdTableViewController: UITableViewController {
    
    var category: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category
        
        // Fetch Ads
        AdController.shared.fetchRecords(category: category)
        
        // Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: AdController.adsWereUpdatedNotification, object: nil)
    }

    
    @IBAction func createAdButtonTapped(_ sender: UIBarButtonItem) {
        createAdAlertController()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if category == "Puppies" {
            return AdController.shared.puppyAds.count
        } else {
            return AdController.shared.kittenAds.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if category == "Puppies" {
            let puppyAd = AdController.shared.puppyAds[indexPath.row]
            cell.textLabel?.text = puppyAd.title
            cell.detailTextLabel?.text = "$\(puppyAd.price)"
        } else {
            let kittenAd = AdController.shared.kittenAds[indexPath.row]
            cell.textLabel?.text = kittenAd.title
            cell.detailTextLabel?.text = "$\(kittenAd.price)"
        }

        return cell
    }

    func createAdAlertController() {
        
        var titleTextField: UITextField?
        var priceTextField: UITextField?
        
        let alertController = UIAlertController(title: "Create New Ad", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField1) in
            textField1.placeholder = "Enter ad title"
            titleTextField = textField1
        }
        alertController.addTextField { (textField2) in
            textField2.placeholder = "Enter ad price"
            textField2.keyboardType = .numberPad
            priceTextField = textField2
    }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let title = titleTextField?.text,
            title != "",
            let price = priceTextField?.text,
            let priceAsInt = Int(price)
                else { return }
           AdController.shared.saveRecordToCloudKit(title: title, price: priceAsInt, category: self.category)
            
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
  }
    @objc func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
