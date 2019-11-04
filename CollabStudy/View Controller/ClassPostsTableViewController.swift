//
//  ClassPostsTableViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/2/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit


class ClassPostsTableViewController: UITableViewController {

    @IBOutlet weak var sc: UISegmentedControl! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func scValueChanges(_ sender: Any) {
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if sc.selectedSegmentIndex == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sc.selectedSegmentIndex == 0 {
            return 650
        }
        else {
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sc.selectedSegmentIndex == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "postscell", for: indexPath) as? PostCellTableViewCell
            
            cell?.postImageView.image = UIImage(named: "3.jpg")
            return cell!
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationcell", for: indexPath)
            
            return cell
        }
        
    }


}
