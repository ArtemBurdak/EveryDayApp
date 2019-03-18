//
//  Item.swift
//  EveryDayApp
//
//  Created by Artem on 2/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation

struct Item: Codable {
    var title: String = ""
    var done: Bool = false
}

enum ItemManager {

    static func getStoredItems() -> [Item] {
        if let data = UserDefaults.standard.value(forKey:"items") as? Data {
            let items = try? PropertyListDecoder().decode(Array<Item>.self, from: data)
            return items ?? []
        } else {
            return []
        }
    }

    static func refreshItem(_ item: Item, items: [Item]) {
        var udatedItems = items

        for (index, var itemCheck) in items.enumerated() {

            if itemCheck.title == item.title {

                itemCheck.done = !item.done

                udatedItems[index] = itemCheck
            }
        }

        UserDefaults.standard.set(try? PropertyListEncoder().encode(udatedItems), forKey: "items")
    }

    static func saveItem(_ item: Item) {
        var savedItems = getStoredItems()
        savedItems.append(item)

        UserDefaults.standard.set(try? PropertyListEncoder().encode(savedItems), forKey: "items")
    }

    static func removeItem(_ item: Item) {
        let savedItems = getStoredItems()
        let filtered = savedItems.filter { $0.title != item.title }

        UserDefaults.standard.set(try? PropertyListEncoder().encode(filtered), forKey: "items")
    }
}
