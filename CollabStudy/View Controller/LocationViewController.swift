//
//  LocationViewController.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/3/19.
//  Copyright © 2019 ASU. All rights reserved.
//

/* https://places.demo.api.here.com/places/v1/discover/search?at=37.7942%2C-122.4070&q=restaurant&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg
 */

import UIKit
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var manager: CLLocationManager!
    
    @IBOutlet weak var getListBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var label: UILabel!
    
    var locationName: String = ""
    var libraryList: libraries = libraries()
    
    var selectedLocationName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.alpha = 0
        
        searchBar.delegate = self
       
        locationName = "Arizona State University"
        label.text = "Currently you are searching for libraries near \(locationName). Click edit to change it"
        
        saveButton.isEnabled = false
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        libraryList.getCount()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return libraryList.getObjectAt(index: row)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var coordinate: CLLocationCoordinate2D?
        let geoCoder = CLGeocoder()
        
        if searchText.isEmpty {
            self.libraryList.library = []
            self.pickerView.reloadAllComponents()
            self.pickerView.alpha = 0
            saveButton.isEnabled = false
        }
        
        geoCoder.geocodeAddressString(locationName) { (placemark, error) in
                
            if error != nil {
                print("\nError-*-: ", error!.localizedDescription)
            } else if placemark!.count > 0 {
                    
                let placemark = placemark![0]
                coordinate = placemark.location?.coordinate
                    
                let latitude = String(format: "%.4f", Double(coordinate!.latitude.description)!)
                let longitude = String(format: "%.4f", Double(coordinate!.longitude.description)!)
                    
            
                let searchString = searchText.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                    
                let urlString = "https://places.demo.api.here.com/places/v1/suggest?at=\(latitude)%2C\(longitude)&q=\(searchString)&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg"
                    
                self.makeAPIcall(latitude: latitude, longitude: longitude, urlString: urlString)
                        
                let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: coordinate!, span: span)
                self.mapView.setRegion(region, animated: true)
                
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                    self.pickerView.alpha = 1
                    
                    self.saveButton.isEnabled = true
                }
                    
            } else {
                print("\nNothing Found. Try Again")
            }
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = libraryList.getObjectAt(index: row)
        
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            
            if error != nil {
                print("\nError (natural language search): ", error!.localizedDescription)
            } else {
                
                var matchingItems: [MKMapItem] = []
                matchingItems = response!.mapItems
                
                let places = matchingItems[0].placemark
                let coordinates = places.location?.coordinate
                let annotation = MKPointAnnotation()
                
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: coordinates! , span: span)
                
                annotation.title = places.name
                annotation.coordinate = coordinates!
                    
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
            }
        }
        
        selectedLocationName = self.libraryList.getObjectAt(index: pickerView.selectedRow(inComponent: 0))
    }
    
    
    private func makeAPIcall(latitude: String, longitude: String, urlString: String) { 
        
        var newResults: [String] = []
        let url = URL(string: urlString)!
        
        let jsonQuery = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("\nError (make api call): ", error!.localizedDescription )
            } else {
                
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let resultDictionary = jsonResult as? [String: AnyObject]
                
                let resultsArray = resultDictionary!["suggestions"] as? NSArray
                
                for result in resultsArray! {
                    newResults.append(result as! String)
                }
                self.libraryList.library = newResults
            }
        }
        jsonQuery.resume()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
       
    }
    
    
    @IBAction func editSearchLocation(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Change Location", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (text) in
            text.placeholder = "Put new location here"
        }
        
        let OKaction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let text = alertController.textFields![0].text {
                self.locationName = text
                self.label.text = "Currently you are searching for libraries near \(self.locationName). Click edit to change it"
            } else {
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in  }
        
        alertController.addAction(OKaction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    
}
