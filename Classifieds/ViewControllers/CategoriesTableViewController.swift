//
//  CategoriesTableViewController.swift
//  Classifieds
//
//  Created by Lewis Jones on 10/03/2019.
//  Copyright © 2019 Rodrigo. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    var categories = ["Puppies", "Kittens"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = self.categories[indexPath.row]
        cell.textLabel?.text = category
    
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToAdList" {
            guard let destinationVC = segue.destination as? AdTableViewController,
            let indexPath = tableView.indexPathForSelectedRow
                else { return }
            let category = self.categories[indexPath.row]
            destinationVC.category = category
        }
    }
}
