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

    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var sc: UISegmentedControl!
    
    var dataFromLocationViewController: String?
    var POST: posts = posts()
    var className: String?
    
    let picker = UIImagePickerController()
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        loadPosts()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "\(className!)"
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

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if sc.selectedSegmentIndex == 0 {
            return POST.getCount()
        } else {
            return 1
        }
    }

   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let postObj = self.POST.getObjectAt(index: self.POST.getCount() - indexPath.section - 1) as? String
        let isURL = Utilities.checkIfURL( urlString: postObj )
        
        if sc.selectedSegmentIndex == 0 {
            if isURL {
                return 480
            } else {
                return 200
            }
        } else {
            return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sc.selectedSegmentIndex == 0 {
            let string = self.POST.getObjectAt(index: self.POST.getCount() - indexPath.section - 1) as? String
            let isURL =  Utilities.checkIfURL(urlString: string)
            
            if isURL {
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? PostCellTableViewCell
                
                let url = URL(string: (self.POST.getObjectAt(index: self.POST.getCount() - indexPath.section - 1) as? String)!)

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
                
                cell!.layer.borderColor = UIColor.black.cgColor
                cell!.layer.borderWidth = 1
                cell!.layer.cornerRadius = 8
                cell!.clipsToBounds = true
                
                return cell!
                
            } else {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "textcell", for: indexPath) as? PostCellTableViewCell
                cell?.labelText.text = self.POST.getObjectAt(index: self.POST.getCount() - indexPath.section - 1) as? String
                cell?.sizeToFit()
                    
                cell!.layer.borderColor = UIColor.black.cgColor
                cell!.layer.borderWidth = 1
                cell!.layer.cornerRadius = 8
                cell!.clipsToBounds = true
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
            
                if snapshot.exists() {
                    let values = snapshot.value! as? [String : AnyObject]
                    self.POST.posts = (values!["posts"]! as? Array)!
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }

    
    @IBAction func addBtnPost(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "", message: "Add a post", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photoAction = UIAlertAction(title: "Photo", style: .default) { (action) in
            
            let nestedAlert = UIAlertController(title: "Select an option", message: "", preferredStyle: .alert)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.picker.allowsEditing = false
                    self.picker.sourceType = UIImagePickerController.SourceType.camera
                    self.picker.cameraCaptureMode = .photo
                    self.picker.modalPresentationStyle = .fullScreen
                    
                    self.present(self.picker, animated: true, completion: nil)
                    
                }
            }
            
            let galleryAction = UIAlertAction(title: "Photo Gallery", style: .default) { (action) in
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.picker.modalPresentationStyle = .popover
                self.present(self.picker, animated: true, completion: nil)
            }
            
            nestedAlert.addAction(cameraAction)
            nestedAlert.addAction(galleryAction)
            self.present(nestedAlert, animated: true, completion: nil)
            
        }
        
        
        let textAction = UIAlertAction(title: "Text", style: .default) { (action) in
            
            let nestedAlert = UIAlertController(title: "Type the text", message: "", preferredStyle: .alert)
            
            nestedAlert.addTextField { (text) in
                text.placeholder = "Type here"
            }
            
            let OKaction = UIAlertAction(title: "OK", style: .default) { (action) in
                
                let dataRef = Database.database().reference().child("classes").child(self.className!)
                
                let text = nestedAlert.textFields![0].text
                
                self.POST.addPost(post: text!)
                dataRef.updateChildValues([ "posts" : self.POST.posts])
               
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
                                    
                                    self.POST.addPost(post: url!.absoluteString)
                                    dataRef.updateChildValues([ "posts" : self.POST.posts])
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
