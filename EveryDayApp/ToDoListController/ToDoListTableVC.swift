//
//  ToDoListTableVC.swift
//  EveryDayApp
//
//  Created by Artem on 2/8/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class ToDoListTableVC: UITableViewController {

    var items = [Item]()

//    let defoults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.Plist")

    override func viewDidLoad() {
        super.viewDidLoad()

        var newItem = Item()
        newItem.title = "kjkbjkbk"
        items.append(newItem)

//        if let items = defoults.array(forKey: Constants.toDoListKey) as? [Item] {
//            itemArray = items
//        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(items), forKey: "items")

        if let data = UserDefaults.standard.value(forKey:"items") as? Data {
            let items = try? PropertyListDecoder().decode(Array<Item>.self, from: data)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.title

        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        items[indexPath.row].done = !items[indexPath.row].done

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addAction(_ sender: Any) {

        var textField = UITextField()

        let alert = UIAlertController(title: "You have new aim?", message: "Set it here!", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add aim", style: .default) { (action) in

            var newItem = Item()
            newItem.title = textField.text!

            self.items.append(newItem)

            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "lose 2 kilos"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}
