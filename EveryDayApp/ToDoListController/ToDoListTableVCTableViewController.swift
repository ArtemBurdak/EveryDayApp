//
//  ToDoListTableVCTableViewController.swift
//  EveryDayApp
//
//  Created by Artem on 2/8/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class ToDoListTableVCTableViewController: UITableViewController {

    var aimArray = ["kk;m", "epmewfm", "ml;;lm"]

    let defoults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        if let aims = defoults.array(forKey: Constants.toDoListKey) as? [String] {
            aimArray = aims
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aimArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
//        let aim = aimArray[indexPath.row]
        cell.textLabel?.text = aimArray[indexPath.row]
        return cell

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        aimArray[indexPath.row].done = !aimArray[indexPath.row].done

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addAction(_ sender: Any) {

        var textField = UITextField()

        let alert = UIAlertController(title: "You have new aim?", message: "Set it here!", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "lose 2 kilos"
        }
        alert.addAction(UIAlertAction(title: "Add aim", style: .default, handler: { [weak alert] (_) in
            self.aimArray.append(textField.text!)

            self.defoults.set(self.aimArray, forKey: Constants.toDoListKey)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
}
