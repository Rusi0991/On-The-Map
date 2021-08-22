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
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Required fields!", message: "Please fill both email and password", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }else {
            
                Student.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
            }
       
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    
    func handleLoginResponse(success : Bool, error : Error?){
        if success {
            print(Student.Auth.sessionId)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toTabViewController", sender: nil)
            }
            
        }
        else{
           
            error?.localizedDescription 
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

