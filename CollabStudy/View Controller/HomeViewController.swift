//
//  HomeViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 10/27/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var classesArr: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar.delegate = self
        loadTable()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classesArr.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = classesArr[indexPath.row]
        
        return cell
    }
    
    
    func loadTable() {
        let childRef = Database.database().reference().child("classes")

        childRef.observe(.value, with: { (snapshot) in
    
            if snapshot.exists() {
                let dic = snapshot.value! as! [String: AnyObject]
                
                self.classesArr = Array(dic.keys)
                self.tableView.reloadData()
            } else {
                print("\nNothing to load\n")
            }
            
        })
    }
    
    
    @IBAction func addBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Class", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (className) in
            className.placeholder = "Enter the course name"
        }
        
        alertController.addTextField { (classNumber) in
            classNumber.placeholder = "Enter the course number"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let className = alertController.textFields![0].text!.uppercased()
            let classDetail = "\(className)\(alertController.textFields![1].text!)"
            
            let childRef = Database.database().reference().child("classes").child(classDetail)
            
            childRef.setValue( [ "classname" : classDetail ] )  { (error, dataRef) in

                if error != nil {
                    print("\n\n \(error!.localizedDescription) \n\n")
                } else {
                    
                }
            }
        }
        
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
}
