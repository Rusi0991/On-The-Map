//
//  ViewController.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/6/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    // Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        hideKeyboardWhenTappedAround()
        
    }

    @IBAction func loginTapped(_ sender: Any) {
        performSegue(withIdentifier: "toTabViewController", sender: (Any).self)
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    
    func handleLoginResponse(success : Bool, error : Error?){
        if success {
            print("createSession")
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
        if textField == emailTextField{
        textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
}

