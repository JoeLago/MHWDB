//
//  WeaponTreeView.swift
//  MHWDB
//
//  Created by Joe on 8/1/20.
//  Copyright © 2020 Gathering Hall Studios. All rights reserved.
//

import SwiftUI

struct WeaponTreeView: View {
    var weaponType: WeaponType
    var weapons: [Weapon]

    init(weaponType: WeaponType) {
        self.weaponType = weaponType
        weapons = Database.shared.weaponTree(type: weaponType)?.array ?? [Weapon]()
    }

    var body: some View {
        List(weapons) {
            ItemDetailCell(
                imageName: $0.icon,
                titleText: $0.name,
                destination: WeaponDetailView(id: $0.id)
            )
        }
        .navigationBarTitle(weaponType.displayName)
    }
}
