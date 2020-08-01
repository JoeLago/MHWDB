//
//  ArmorComponent.swift
//  MHWDB
//
//  Created by Joe on 5/13/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import GRDB

class ArmorComponent: FetchableRecord, Decodable, Identifiable {
    var id: Int { return itemId }
    var itemId: Int
    var name: String
    var icon: String?
    var type: String?
    var quantity: Int?
}

extension Database {
    func armorComponents(armorId: Int) -> [ArmorComponent] {
        let query = Query(table: "armor_recipe")
            .join(table: "item", on: "item_id")
            .join(origin: "item", table: "item_text")
            .filter("armor_id", equals: armorId)
        return fetch(query)
    }
}
