//
//  ProfileViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/2/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImage: UIImageView! {
       didSet {
            profileImage.layer.cornerRadius = profileImage.bounds.height / 2
            profileImage.clipsToBounds = true
            profileImage.contentMode = .scaleAspectFill
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var logOut: UIButton!
    
    let picker = UIImagePickerController()
    let uid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        fillNameAndEmailfield()
        loadProfileImage()
        
    }
    
    private func fillNameAndEmailfield() {
    
        
        let dataRef = Database.database().reference()
        let childRef = dataRef.child("users").child((uid)!)
        
        self.emailLabel.text = Auth.auth().currentUser?.email
                        
        DispatchQueue.global(qos: .userInteractive).async {
            childRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                self.nameLabel.text = "\(value?["firstname"] as! String) \(value?["lastname"] as! String)"
            })
        }
    }
    
    
    private func loadProfileImage() {
        let dataRef = Database.database().reference().child("profileImage").child(uid!)
        
        dataRef.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists() {
                let value = snapshot.value as? String
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = try? Data(contentsOf: URL(string: value!)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.profileImage.image = image
                            }
                        }
                    }
                }
               
            }
            
        }
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
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Choose an option", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                
                self.present(self.picker, animated: true, completion: nil)
                
            }
        }
        
        let galaryAction = UIAlertAction(title: "Photo Gallery", style: .default) { (action) in
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        
        alertController.addAction(cameraAction)
        alertController.addAction(galaryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = pickedImage
            
            let storageRef = Storage.storage().reference().child("profileImage/").child(uid!)
            let dataRef = Database.database().reference().child("profileImage").child(uid!)
            
            storageRef.putData(pickedImage.jpegData(compressionQuality: 0)!, metadata: nil) { (metaData, error) in
                
                if error != nil {
                    print("\nError saving profile image: ", error!.localizedDescription)
                } else {
                    
                    storageRef.downloadURL { (url, error) in
                        
                        if error != nil {
                            print("\nError downloading URL: ", error!.localizedDescription)
                        } else {
                            
                            DispatchQueue.init(label: "Custom", qos: .userInitiated, attributes: .concurrent).async(execute: {
                                dataRef.setValue(url?.absoluteString)
                            })
                            
                        }
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
