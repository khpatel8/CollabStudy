//
//  LocationViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/3/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    @IBOutlet weak var getListBtn: UIButton! {
        didSet {
            Utilities.styleFilledButton(self.getListBtn)
        }
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func getListActiontBtn(_ sender: UIButton) {
        
        
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
