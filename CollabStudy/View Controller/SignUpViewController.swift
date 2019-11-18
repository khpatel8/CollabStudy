//
//  SignUpViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 10/27/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        let error = validateInputs()
        
        if error != nil {
            self.showError(error!)
        } else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    self.showError((error?.localizedDescription)!)
                } else {
                    let databaseRef = Database.database().reference().child("users")
                    
                    databaseRef.child((result?.user.uid)!).setValue([ "firstname": firstName, "lastname" : lastName ])
                    
                    self.transtitionToHome()
                }
            }
        }
    }
    
    func transtitionToHome() {
        
        let homeVC = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController

        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }

    func validateInputs() -> String? {
        
        if firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            
            return "Make sure to fill all the text fields"
        } else {
            
            let isValid = Utilities.isPasswordValid(passwordTextField.text!)
            
            if !isValid {
                return "Password needs to be 8 characters long with a special character and a number"
            }
        }
        return nil
    }
    
    
    func showError(_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }
    
    
    func setUpUI() {
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }

}
