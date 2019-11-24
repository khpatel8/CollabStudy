//
//  ClassListViewController.swift
//  
//
//  Created by Kunj Patel on 11/2/19.
//

import UIKit
import FirebaseAuth
import Firebase


class ClassListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var classListArr: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
        loadClassList()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classListArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = classListArr[indexPath.row]
        return cell
    }
    
     
    private func loadClassList() {
        let uid = Auth.auth().currentUser?.uid
        let childRef = Database.database().reference().child(uid!)
        
            childRef.observe(.value) { (snapshot) in
                
                if snapshot.exists() {
                    let arr = snapshot.value! as? [String]
                    self.classListArr = Array(arr!)
                    self.tableView.reloadData()
                } else {
                    print("\nNothing to load")
                }
                
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath: IndexPath = self.tableView!.indexPathForSelectedRow!
        
        if let destination = segue.destination as? ClassPostsTableViewController {
            destination.className = classListArr[indexPath.row]
        }
    }
    
}
