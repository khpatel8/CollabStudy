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
    
    var classesArray: [String] = []
    
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
        view.endEditing(true)
        return true
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classesArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AvailableClassesTableViewCell
        
        cell.textLabel?.text = classesArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = Auth.auth().currentUser?.uid
        let chilRef = Database.database().reference().child(uid!)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        
        chilRef.observeSingleEvent(of: .value) { (snapshot) in
            var arr: [String] = []
            var found: Bool = false
            
            if snapshot.exists() {
                arr = (snapshot.value! as? [String])!
                
                for x in arr {
                    if x == cell?.textLabel!.text {  found = true }
                }
            }
            
            if found == false {
                arr.append((cell?.textLabel!.text)!)
                chilRef.setValue(arr) { (error, dataRef) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func loadTable() {
        let childRef = Database.database().reference().child("classes")

        childRef.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let dic = snapshot.value! as! [String: AnyObject]
                
                self.classesArray = Array(dic.keys).sorted()
                self.tableView.reloadData()
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

            DispatchQueue.main.async {
                childRef.setValue( ["posts" : ["Welcome to the discussion "] ] )  { (error, dataRef) in

                    if error != nil {
                        print("\n\n \(error!.localizedDescription) \n\n")
                    } else {

                    }
                }
            }
        }
        
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    
}
