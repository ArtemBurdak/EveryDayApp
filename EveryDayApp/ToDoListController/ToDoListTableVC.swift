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

    override func viewDidLoad() {
        super.viewDidLoad()

        updateItemsFromMemory()
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

        ItemManager.refreshItem(items[indexPath.row], items: items)

        updateItemsFromMemory()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addAction(_ sender: Any) {

        var textField = UITextField()

        let alert = UIAlertController(title: "You have new aim?", message: "Set it here!", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add aim", style: .default) { (action) in

            var newItem = Item()
            newItem.title = textField.text!

            ItemManager.saveItem(newItem)

            self.updateItemsFromMemory()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "lose 2 kilos"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    func updateItemsFromMemory() {
        items = ItemManager.getStoredItems()
        tableView.reloadData()
    }
}
