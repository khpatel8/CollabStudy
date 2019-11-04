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
    
    @IBOutlet weak var logOut: UIButton! {
        didSet {
            Utilities.styleFilledButton(self.logOut)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillNameAndEmailfield()
        // Do any additional setup after loading the view.
        
    }
    
    private func fillNameAndEmailfield() {
    
        let uid = Auth.auth().currentUser?.uid
        let dataRef = Database.database().reference()
        let childRef = dataRef.child("users").child((uid)!)
        
        DispatchQueue.main.async {
            self.emailLabel.text = Auth.auth().currentUser?.email
        }
        
        childRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            DispatchQueue.main.async {
                self.nameLabel.text = " \(value?["firstname"] as! String) \(value?["lastname"] as! String)"
            }
        })
  
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        do {
              try Auth.auth().signOut()
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
