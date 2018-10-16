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

class PhotoMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pinImage: UIImage!
    
    lazy var annotations = [MKAnnotation]()
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagSegue" {
            let destination = segue.destination as? LocationsViewController
            destination?.delegate = self
        } else if segue.identifier == "fullImageSegue" {
            let destination = segue.destination as! FullImageViewController
            destination.linkerImage = pinImage
        }
        
    }
}

extension PhotoMapViewController: MKMapViewDelegate {
    
    func addPin(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let annotation = PhotoAnnotation()
        annotation.photo = self.pinImage
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = locationCoordinate
        self.mapView.addAnnotation(annotation)
        self.annotations.append(annotation)
        self.mapView.showAnnotations(self.annotations, animated: true)
    }
    
    //Detect an annotation press
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title! {
                print("Tapped \(title) pin")
            }
        }
    }
    
    func resize(image: UIImage?, newSize: CGSize) -> UIImage? {
        if let image = image{
            let resizeImageView = UIImageView(frame: CGRect(x: 0, y:0, width: newSize.width, height: newSize.height))
            resizeImageView.contentMode = .scaleAspectFill
            resizeImageView.image = image
            
            UIGraphicsBeginImageContext(resizeImageView.frame.size)
            resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            /// show the callout "bubble" when annotation view is selected
            annotationView?.canShowCallout = true
        }
        
        let thumbnail = self.resize(image: self.pinImage, newSize: CGSize(width: 60, height: 60))
        
        annotationView?.image = thumbnail
        
        //configure left accessory view
        let leftViewFrame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let imageLeftView = UIImageView(frame: leftViewFrame)
        
        imageLeftView.layer.borderColor = UIColor.white.cgColor
        imageLeftView.contentMode = .scaleAspectFill
        imageLeftView.image = (annotation as? PhotoAnnotation)?.photo
        imageLeftView.image = thumbnail
        imageLeftView.backgroundColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0)
        annotationView?.leftCalloutAccessoryView = imageLeftView
        
        //configure right accessory view
        let arrowBtnFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let arrowBtn = UIButton(frame: arrowBtnFrame)
        //arrowBtn.setImage( #imageLiteral(resourceName: "arrow-icon"), for: .normal)
        annotationView?.rightCalloutAccessoryView = arrowBtn
        
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        let resizeRenderImageView = UIImageView(frame: CGRect(x:0, y:0, width:45, height:45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 5.0
        resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
        //resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo
        
        
        resizeRenderImageView.image = pinImage
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in:UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = thumbnail
        UIGraphicsEndImageContext()
        
        if let photoAnnotation = annotation as? PhotoAnnotation {
            
            
            
            if (annotationView == nil) {
                annotationView = MKPinAnnotationView(annotation: photoAnnotation, reuseIdentifier: reuseID)
                annotationView!.canShowCallout = true
                annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
                annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            }
            
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        performSegue(withIdentifier: "fullImageSegue", sender: nil)
    }
 
    */
}

extension PhotoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
}

extension PhotoMapViewController: LocationsViewControllerDelegate {
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        self.navigationController?.popToViewController(self, animated: true)
        
        self.addPin(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        /*
        
        let annotation = PhotoAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        annotation.photo = self.pinImage
        //annotation.title = "\(latitude), \(longitude)"
        self.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.1, 0.1))
        self.mapView.setRegion(region, animated: true)
        */
        
        
    }
}
