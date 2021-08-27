//
//  TableTabbedViewController.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/7/21.
//

import UIKit

class TableTabbedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        Student.getStudentsLocations { studentlocationresults, error in
            
            if error == nil {
                StudentModel.locations = studentlocationresults
                self.tableView.reloadData()
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Data couldn't load", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
         }
        
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if Student.User.createdAt == ""{
            performSegue(withIdentifier: "toInformationVC", sender: nil)
        } else {
            showAlert()
        }
    }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        Student.getStudentsLocations { studentlocationresults, error in
            
                StudentModel.locations = studentlocationresults
                self.tableView.reloadData()
    }
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell")!
        let student = StudentModel.locations[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.locations.count
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
