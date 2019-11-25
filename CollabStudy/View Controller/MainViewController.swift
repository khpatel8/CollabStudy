//
//  ViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 10/27/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    var isKeepMeSignedInChecked: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.imageView.image = UIImage(named: "9.jpg")
        setUpUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true && UserDefaults.standard.bool(forKey: "isKeepMeSignedInChecked") == true  {
            self.transtitionToHome()
        }
    }
    
    
    func setUpUI() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(logInButton)
    }
    

    @IBAction func checkBoxTapped(_ sender: Any) {
        if isKeepMeSignedInChecked == true {
            isKeepMeSignedInChecked = false
            self.checkBoxOutlet.setImage(UIImage(named: "unchecked.png"), for: .normal)
            UserDefaults.standard.set(false, forKey: "isKeepMeSignedInChecked")
        } else {
            isKeepMeSignedInChecked = true
            self.checkBoxOutlet.setImage(UIImage(named: "checked.png"), for: .normal)
            
            UserDefaults.standard.set(true, forKey: "isKeepMeSignedInChecked")
        }
    }
    
    
    func transtitionToHome() {
        let homeVC = storyboard?.instantiateViewController(identifier: "tab")
        self.navigationController?.pushViewController(homeVC!, animated: false)
    }
    
}

