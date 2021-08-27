//
//  MapViewController.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/7/21.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        showPins()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showPins()
    }
    @IBAction func addLocation(_ sender: Any) {
        if Student.User.createdAt == ""{
            performSegue(withIdentifier: "InformationPostingViewController", sender: nil)
        } else {
            showAlert()
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        showPins()
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        Student.logout { success, error in
            if success{
                self.dismiss(animated: true, completion: nil)

                print("logged out")
            }else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed", message: "Could not log out. Try again", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func showPins(){
        //        data that you can download from parse.
        Student.getStudentsLocations { studentlocationresults, error in
            
            if error == nil {
                StudentModel.locations = studentlocationresults
                
                //        The point annotations will be stored in this array, and then provided to the map view.
                var annotations = [MKPointAnnotation]()
                
                // The "student" array is loaded with the sample data below. We are using the dictionaries
                // to create map annotations. This would be more stylish if the dictionaries were being
                // used to create custom structs. Perhaps StudentLocation structs.
                for student in StudentModel.locations {
                    
                    let lat = CLLocationDegrees(student.latitude )
                    let long = CLLocationDegrees(student.longitude)
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D( latitude:lat, longitude: long)
                    annotation.title = "\(student.firstName)" + " " + "\(student.lastName)"
                    annotation.subtitle = student.mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                    self.mapView.addAnnotation(annotation)
                }
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Data couldn't load", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if  pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!{
                app.canOpenURL(URL(string: toOpen)!)
                app.open(URL(string: toOpen)!)
            }
            
        }
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Warning", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
            if let vc = self.storyboard?.instantiateViewController(identifier: "toInputVC") as? InformationPostingViewController{
                
                vc.loadView() 
                vc.viewDidLoad()
                vc.linkTextField.text = Student.User.link
                vc.locationTextField.text = Student.User.location
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                fatalError("alert error")
            }
        }
        let okAction2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(okAction2)
        present(alert, animated: true, completion: nil)
        
    }
}
