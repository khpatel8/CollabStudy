//
//  ClassPostsTableViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/2/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit


class ClassPostsTableViewController: UITableViewController {

    //var Posts: [postModel] = []
    var text1: [Any] = []
    var img: [UIImage] = []
    
    @IBOutlet weak var sc: UISegmentedControl! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPosts()
    }

    @IBAction func scValueChanges(_ sender: Any) {
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if sc.selectedSegmentIndex == 0 {
            return text1.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sc.selectedSegmentIndex == 0 {
            return 100
        }
        else {
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sc.selectedSegmentIndex == 0 {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textcell", for: indexPath) as? PostCellTableViewCell
                
            cell?.textLabel?.text = text1[indexPath.row] as? String
            cell?.textLabel?.textAlignment = .left
                
            return cell!
            
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationcell", for: indexPath)
            return cell
        }
    }
    
    private func loadPosts() {
        
    }

    @IBAction func addBtnPost(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Add a post", message: "Add a post", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photo", style: .default) { (action) in
        }
        
        let textAction = UIAlertAction(title: "Text", style: .default) { (action) in
            
            let nestedAlert = UIAlertController(title: "Type the text", message: "", preferredStyle: .alert)
            
            nestedAlert.addTextField { (text) in
                text.placeholder = "Type here"
            }
            
            let OKaction = UIAlertAction(title: "OK", style: .default) { (action) in
                
                let text = nestedAlert.textFields![0].text
                
                print("\n\n", text!)
               
                    self.text1.append(text!)
                
                self.tableView.reloadData()
            }
            
            nestedAlert.addAction(OKaction)
            self.present(nestedAlert, animated: true)
            
        }

        ac.addAction(photoAction)
        ac.addAction(textAction)
        present(ac, animated: true)
        
    }
    
}
