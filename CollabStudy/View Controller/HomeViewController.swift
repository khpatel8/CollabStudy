//
//  HomeViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 10/27/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var logOutBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observe(.value, with: { (snapshot) in
            
            print(snapshot.value!)
        })
    }
 
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
