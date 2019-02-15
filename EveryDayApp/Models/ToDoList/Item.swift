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
    var favorite: Bool = false
}


//enum ItemesManager {
//
//    static func getStoredItems() -> [Item] {
//        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
//            let items = try? PropertyListDecoder().decode(Array<Item>.self, from: data)
//            return items ?? []
//        } else {
//            return []
//        }
//    }
//
//    static func saveItems(_ item: Item) {
//        var storedItems = getStoredItems()
//        storedItems.append(item)
//
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(storedItems), forKey: "items")
//    }
//
//    static func removeFavorite(_ item: Item) {
//        let storedItems = getStoredItems()
//        let filtered = storedItems.filter { $0.done != item.done }
//
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(filtered), forKey: "items")
//    }
//}
