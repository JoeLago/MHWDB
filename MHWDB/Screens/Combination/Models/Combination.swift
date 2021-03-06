//
// MIT License
// Copyright (c) Gathering Hall Studios
//

import Foundation
import GRDB

class Combination: FetchableRecord, Decodable, Identifiable {
    var id: Int
    var quantity: Int

    // TODO: Should try to abstract each item.  Possible with GRDB without adding a bunch of decodable boilerplate?

    var resultId: Int
    var resultName: String
    var resultIconName: String?
    var resultIconColor: IconColor?
    var resultIcon: Icon? { Icon(name: resultIconName.map { "items_\($0)".lowercased() }, color: resultIconColor) }

    var firstId: Int
    var firstName: String
    var firstIconName: String?
    var firstIconColor: IconColor?
    var firstIcon: Icon? { Icon(name: firstIconName.map { "items_\($0)".lowercased() }, color: firstIconColor) }

    var secondId: Int
    var secondName: String
    var secondIconName: String?
    var secondIconColor: IconColor?
    var secondIcon: Icon? { Icon(name: secondIconName.map { "items_\($0)".lowercased() }, color: secondIconColor) }

    lazy var created: Item = { return Database.shared.item(id: self.resultId) }()
    lazy var first: Item = { return Database.shared.item(id: self.firstId) }()
    lazy var second: Item = { return Database.shared.item(id: self.secondId) }()
}

private extension Query {
    func joinItem(on name: String) -> Query {
        self.join(table: "item", as: name, on: "\(name)_id")
            .join(origin: name, table: "item_text", as: "\(name)_text", addLanguageFilter: true)
            .column("\(name).id", as: "\(name)Id")
            .column("\(name)_text.name", as: "\(name)Name")
            .column("\(name).icon_name", as: "\(name)IconName")
            .column("\(name).icon_color", as: "\(name)IconColor")
        return self
    }
}

extension Database {

    var combinationQuery: Query {
        let query = Query(table: "item_combination", addLanguageFilter: false)
            .joinItem(on: "result")
            .joinItem(on: "first")
            .joinItem(on: "second")
        return query
    }

    func addIconColumns(query: Query, table: String, textTable: String) -> Query {
        query.column("result.id", as: "createdId")
            .column("result_text.name", as: "createdName")
            .column("result.icon_name", as: "createdIcon")
        return query
    }

    func combination(id: Int) -> Combination {
        let query = combinationQuery.filter("result_id", equals: id)
        return fetch(query)[0]
    }

    func combinations(itemId: Int) -> [Combination] {
        let query = combinationQuery.orFilter([
            Query.Filter(attribute: "result_id", value: itemId),
            Query.Filter(attribute: "first_id", value: itemId),
            Query.Filter(attribute: "second_id", value: itemId)
            ])
        return fetch(query)
    }

    func combinations() -> [Combination] {
        return fetch(combinationQuery)
    }
}
