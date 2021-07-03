//
//  ViewController.swift
//  Test1
//
//  Created by Семён Кривцов on 03.07.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    private let cellID = "cell"
    private var childs: [Child] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        // Table view cell register
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.isEditing = true
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    // Setup navigation bar
    private func setupNavigationBar() {
        
        // Set title navigation bar
        title = "Your Children"
        
        // Title color
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Navigation bar color
        navigationController?.navigationBar.barTintColor = UIColor(
            displayP3Red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "+",
            style: .plain,
            target: self,
            action: #selector(addNewChild)
        )
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc private func addNewChild() {
        showAlert(title: "Add new child", message: "Enter the child's name and age")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else {
                print("The text field is empty")
                return
            }
            
            guard let age = alert.textFields?.last?.text, Int(age) != nil else {
                print("The age field is empty or has an invalid value")
                return
            }
        
            // Add new child to childs array
            guard let age = Int(age) else { return }
            let child = Child(name: name, age: age)
            self.childs.append(child)
            
            self.tableView.insertRows(at: [IndexPath(row: self.childs.count - 1, section: 0)],
                                      with: .automatic)
    }
    
        let cencelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField { name in
            name.placeholder = "Name"
        }
        
        alert.addTextField { age in
            age.placeholder = "Age"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cencelAction)
        
        present(alert, animated: true)
    }
}

// MARK:  UITableViewDataSource
extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let child = childs[indexPath.row]
        cell.textLabel?.text = "Name: \(child.name)\nAge: \(child.age)"
        cell.textLabel?.numberOfLines = 0
        
        if childs.count > 4 {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.title = ""
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            childs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        if childs.count < 5 {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.title = "+"
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let selectedChild = childs[sourceIndexPath.row]
            childs.remove(at: sourceIndexPath.row)
            childs.insert(selectedChild, at: destinationIndexPath.row)
    }

}
