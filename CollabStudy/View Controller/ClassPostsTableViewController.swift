//
//  ClassPostsTableViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/2/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase

class ClassPostsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let picker = UIImagePickerController()
    var className: String?
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    var posts: [Any] = []
    
    @IBOutlet weak var sc: UISegmentedControl!
    
    var dataFromLocationViewController: String?
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        loadPosts()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }

    
    @IBAction func scValueChanges(_ sender: Any) {
        if sc.selectedSegmentIndex == 1{
            addBtn.isEnabled = false
        } else {
            addBtn.isEnabled = true
        }
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sc.selectedSegmentIndex == 0 {
            return posts.count
        } else {
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isURL = Utilities.checkIfURL(urlString: self.posts[self.posts.count - indexPath.row - 1] as? String)
        
        if sc.selectedSegmentIndex == 0 {
            if isURL {
                return 463
            } else {
                return 200
            }
        } else {
            return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sc.selectedSegmentIndex == 0 {
            let string = self.posts[self.posts.count - indexPath.row - 1] as! String
            let isURL =  Utilities.checkIfURL(urlString: string)
            
            if isURL {
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? PostCellTableViewCell
                
                let url = URL(string: (self.posts[self.posts.count - indexPath.row - 1] as? String)!)

                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell?.postImageView?.image = image
                                cell?.postImageView?.contentMode = .scaleAspectFill
                            }
                        }
                    }
                }
                
                return cell!
                
            } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textcell", for: indexPath) as? PostCellTableViewCell
            cell?.labelText.text = self.posts[self.posts.count - indexPath.row - 1] as? String
            cell?.sizeToFit()
            return cell!
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationcell", for: indexPath)
            cell.textLabel?.text = dataFromLocationViewController
            cell.detailTextLabel?.text = "See or Set the group location"
            return cell
        }
    }
    
    
    private func loadPosts() {
        let dataRef = Database.database().reference().child("classes").child(self.className!)
            
        dataRef.observe(.value) { (snapshot) in
                
                let values = snapshot.value! as? [String : AnyObject]
                    
                if snapshot.exists() {
                    self.posts = (values!["posts"]! as? Array)!
                }
                
                DispatchQueue.main.async {
                    print("\n\nReload from loadPosts()")
                    print("\nCount: ", self.posts.count, "\nPosts", self.posts)
                    self.tableView.reloadData()
                }
            }
    }

    
    @IBAction func addBtnPost(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "", message: "Add a post", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photoAction = UIAlertAction(title: "Photo", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                
                self.present(self.picker, animated: true, completion: nil)
                
            } else {
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.picker.modalPresentationStyle = .popover
                self.present(self.picker, animated: true, completion: nil)
            }
        }
        
        
        let textAction = UIAlertAction(title: "Text", style: .default) { (action) in
            
            let nestedAlert = UIAlertController(title: "Type the text", message: "", preferredStyle: .alert)
            
            nestedAlert.addTextField { (text) in
                text.placeholder = "Type here"
            }
            
            let OKaction = UIAlertAction(title: "OK", style: .default) { (action) in
                
                let dataRef = Database.database().reference().child("classes").child(self.className!)
                
                let text = nestedAlert.textFields![0].text
                
                self.posts.append(text!)
                dataRef.updateChildValues([ "posts" : self.posts])
               
            }
            
            nestedAlert.addAction(OKaction)
            self.present(nestedAlert, animated: true)
            
        }
        
        ac.addAction(cancelAction)
        ac.addAction(photoAction)
        ac.addAction(textAction)
        present(ac, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("images/").child("\(imageName).jpg")
            let dataRef = Database.database().reference().child("classes").child(self.className!)
            
            
            storageRef.putData(pickedImage.jpegData(compressionQuality: 0)!, metadata: nil) { (metaData, error) in
                    
                    if error != nil {
                        print("Error: ", error!.localizedDescription)
                    } else {
                        storageRef.downloadURL { (url, error) in
                                
                            if error != nil {
                                print("Error: ", error!.localizedDescription)
                            } else {
                                
                                DispatchQueue.init(label: "Custom", qos: .userInitiated, attributes: .concurrent).async(execute: {
                                    
                                    self.posts.append( url!.absoluteString )
                                    dataRef.updateChildValues([ "posts" : self.posts])
                                    })
                            }
                        }
                    }
                }
        }
          dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToVC(sender: UIStoryboardSegue) {
        if let source = sender.source as? LocationViewController {
            dataFromLocationViewController = source.selectedLocationName
            self.tableView.reloadData()
        }
    
    }
    
}
