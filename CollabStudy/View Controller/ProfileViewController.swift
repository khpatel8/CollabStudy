//
//  ProfileViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/2/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var logOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        fillNameAndEmailfield()
        // Do any additional setup after loading the view.
        
    }
    
    private func fillNameAndEmailfield() {
    
        let uid = Auth.auth().currentUser?.uid
        let dataRef = Database.database().reference()
        let childRef = dataRef.child("users").child((uid)!)
        
        self.emailLabel.text = Auth.auth().currentUser?.email
                
        childRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
                self.nameLabel.text = "\(value?["firstname"] as! String) \(value?["lastname"] as! String)"
        })
  
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(false, forKey: "isKeepMeSignedInChecked")
            self.transtitionToMain()
        } catch {
            print("Error signing out")
        }
    }
    
    func transtitionToMain() {
         let mainVC = storyboard?.instantiateViewController(identifier: "main")
         view.window?.rootViewController = mainVC
         view.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func editBtn(_ sender: Any) {
        
    }
    
}
