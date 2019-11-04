//
//  ViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 10/27/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.imageView.image = UIImage(named: "9.jpg")
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setUpUI() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(logInButton)
    }

}

