//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI
import MessageUI

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pinImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
    }
    
    private func initMap() {
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func onPhotoClicked(_ sender: UIButton) {
        initImageController()
    }
    
    private func initImageController() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.pinImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: {
             self.performSegue(withIdentifier: "tagSegue", sender: self)
        })
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        self.navigationController?.popToViewController(self, animated: true)
        /*
        let locationCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let region = MKCoordinateRegionMake(locationCoordinates, MKCoordinateSpanMake(0.1, 0.1))
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinates
        annotation.title = "\(latitude), \(longitude)"
        self.mapView.addAnnotation(annotation)
        */
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? LocationsViewController
        destination?.delegate = self
    }
}
