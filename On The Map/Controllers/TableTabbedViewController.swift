//
//  TableTabbedViewController.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/7/21.
//

import UIKit

class TableTabbedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var students = [StudentLocation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableTabbedViewCell")!
        let student = students[indexPath.row]
        cell.textLabel?.text = student.firstName + student.lastName
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

}
