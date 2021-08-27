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
        navigationController?.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = true
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
        UIApplication.shared.open(Student.Endpoints.webAuth.url, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success : Bool, error : Error?){
        if success {
            print(Student.Auth.sessionId)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toTabViewController", sender: nil)
            }
            
        }
        else{
           
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLoginFailure(message: String){
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
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

