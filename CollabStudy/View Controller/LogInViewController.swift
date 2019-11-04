//
//  LogInViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 10/27/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func logInButton(_ sender: Any) {
        let error = self.validateInputs()
        
        if(error != nil) {
            self.showError(error!)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (result, error) in
                    
                    if error != nil {
                        self.showError("Something went wrong")
                    } else {
                        self.transtitionToHome()
                        
                    }
                }
        }
    }
    

    func transtitionToHome() {
        let homeVC = storyboard?.instantiateViewController(identifier: "tab")
        
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
    
    func validateInputs() -> String? {
        
        if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||  passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            
            return "Make sure to fill all the text fields"
        } else {
            
            let isValid = Utilities.isPasswordValid(passwordTextField.text!)
            
            if !isValid {
                return "Password needs to be 8 characters long with a special character and a number"
            }
        }
        return nil
    }
    
    
    func setUpUI() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(logInButton)
    }
    
    func showError(_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
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
