//
//  Melody.swift
//  MHWDB
//
//  Created by Joe on 9/7/20.
//  Copyright © 2020 Gathering Hall Studios. All rights reserved.
//

import Foundation
import GRDB
import SwiftUI

struct Melody: Decodable, FetchableRecord, Identifiable {
    var id: Int
    var name: String
    var effect1: String
    var effect2: String
    var baseDuration: Int?
    var baseExtension: Int?
    var m1Duration: Int?
    var m1Extension: Int?
    var m2Duration: Int?
    var m2Extension: Int?

    var notes: String

    var isValidSong: Bool {
        var uniqueWeaponNotes = Set<Character>()
        weaponNotes.forEach { uniqueWeaponNotes.insert($0) }
        return uniqueNotes.isSubset(of: uniqueWeaponNotes)
    }
    var weaponNotes: String
    var uniqueNotes: Set<Character> {
        var uniqueNotes = Set<Character>()
        notes.forEach { uniqueNotes.insert($0) }
        uniqueNotes.remove("E")
        return uniqueNotes
    }

    var icons: [Icon] {
        notes.map { Icon(note: $0, weaponNotes: weaponNotes) }
    }
}

extension Icon {
    init(note: Character, weaponNotes: String) {
        self.init(
            name: note == "E" ? "note_echo" : "note_\((weaponNotes.indexInt(of: note) ?? 0) + 1)",
            color: Self.color(note: note)
        )
    }

    static func color(note: Character) -> IconColor {
        switch note {
        case "W": return .white
        case "R": return .red
        case "B": return .blue
        case "O": return .orange
        case "Y": return .yellow
        case "P": return .darkPurple
        case "G": return .green
        case "C": return .cyan
        default: return .white
        }
    }
}

extension Database {

    func melodies(weaponNotes: String) -> [Melody] {
        let query = Query(table: "weapon_melody")
            .column("'\(weaponNotes)'", as: "weapon_notes") // forcing weapon notes into results for decoder
            .join(table: "weapon_melody_text")
            .join(table: "weapon_melody_notes")
        return fetch(query).filter { $0.isValidSong }
    }
}
