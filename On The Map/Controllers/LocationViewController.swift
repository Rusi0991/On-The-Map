//
//  LocationViewController.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/22/21.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var link : String = ""
    var location : String = ""
    var latitude : Double = 0.0
    var longitude: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func finishButtonTapped(_ sender: Any) {
        
        Student.getPublicUserData(completion: handlePublicUserData(firstName:lastName:error:))
    }
    
    func handlePublicUserData(firstName : String?, lastName : String? , error : Error? ){
        if error == nil {
            Student.postStudentLocation(firstName: firstName ?? "", lastName: lastName ?? "" , mapString: location, mediaURL: link, longitude: longitude, latitude: latitude, completion: handlePostStudentLocation(success:error:))
        } else {
            print("User data cannot be handled")
        }
        }
    
    func handlePostStudentLocation(success: Bool, error: Error?){
        
        if success {
            Student.User.location = location
            print(Student.User.location)
            Student.User.link = link
            print("student added")
            navigationController?.popToRootViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "Error", message: "Student could not added. Try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            print("student could not be added.")
        }
    }
    
    }
    

