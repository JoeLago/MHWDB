//
// MIT License
// Copyright (c) Gathering Hall Studios
//

import UIKit

class ItemDetails: TableController, DetailScreen {
    var id: Int

    convenience required init(id: Int) {
        self.init(item: Database.shared.item(id: id))
    }

    init(item: Item) {
        id = item.id
        super.init()
        title = item.name
        addSimpleSection(data: [item])
        add(section: ItemDetailSection(item: item))
        /*addCustomSection(title: "Combinations",
                         data: item.combinations.map {
                            CombinationCellModel(combination: $0, itemSelected: { self.push(ItemDetails(id: $0)) }) },
                         cellType: CombinationCell.self)*/
        //addSimpleSection(data: item.quests, title: "Quest Rewards") { QuestDetails(id: $0.questId) }
        addSimpleSection(data: item.locations, title: "Locations") { LocationDetails(id: $0.id) }
        addSimpleSection(data: item.monsters, title: "Rewards") { MonsterDetails(id: $0.monsterId) }
        addSimpleSection(data: item.armor, title: "Armor") { ArmorDetails(id: $0.createdId) }
        addSimpleSection(data: item.weapons, title: "Weapons") { WeaponDetails(id: $0.createdId) }
        addSimpleSection(data: item.charms, title: "Charms") { DecorationDetails(id: $0.createdId) }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemQuest: DetailCellModel {
    var primary: String? { return "\(name) - \(slot)" }
    var subtitle: String? { return "\(stars)\(String.star) \(hub)" }
    var secondary: String? { return "\(quantity > 1 ? "x\(quantity) " : "") \(Int(chance))%" }
    var imageName: String? { return icon }
}

extension ItemLocation: DetailCellModel {
    var primary: String? { return [rank, name].compactMap({ $0 }).joined(separator: " ") }
    var imageName: String? { return icon }
    var subtitle: String? { return nodeName }
    var secondary: String? { return "\(stack ?? 0 > 1 ? "x\(stack ?? 0) ": "")\(percentage ?? 0)%" }
}

extension ItemMonster: DetailCellModel {
    var primary: String? { return "\(rank.rawValue) \(name)" }
    var imageName: String? { return icon }
    var subtitle: String? { return "\(condition)" }
    var secondary: String? { return "\(stack > 1 ? "x\(stack) ": "")\(chance)%" }
}

extension ItemComponent: DetailCellModel {
    var primary: String? { return name }
    var imageName: String? { return icon }
    var secondary: String? { return "x \(quantity)" }
}