//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/16/21.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    var latitude : Double = 0.0
    var longitude : Double = 0.0 // -> (CLLocationCoordinate2D(latitude:Double, logitude: Double))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func findLocationTapped(_ sender: Any) {
        guard let location = locationTextField.text else {return}
        findGeocode("\(location)")
        
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func findGeocode(_ address: String) {
        
        CLGeocoder().geocodeAddressString(address) { (placemark, error)
            in
            if error == nil {
                
                if let placemark = placemark?.first,
                   let location = placemark.location {
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    
                    print("Latitude:\(self.latitude), Longitude:\(self.longitude)")
                
                    self.performSegue(withIdentifier: "toLocationVC", sender: nil)
                }
                
            }else {
                let alert = UIAlertController(title: "Error", message: "Geocode could not find. Try again", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                print("geocode error")
            }

}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocationVC" {
            if let mapVC = segue.destination as? LocationViewController {
                mapVC.link = linkTextField.text ?? ""
                mapVC.location = locationTextField.text ?? ""
                mapVC.latitude = latitude
                mapVC.longitude = longitude
            }
        }
    }
    func hideKeyboardWhenTappedAround() {
           let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == locationTextField{
        textField.resignFirstResponder()
            linkTextField.becomeFirstResponder()
        }
        return true
    }
}
