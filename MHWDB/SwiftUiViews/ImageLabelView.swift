//
//  ImageLabelSwift.swift
//  MHWDB
//
//  Created by Joe on 7/26/20.
//  Copyright © 2020 Gathering Hall Studios. All rights reserved.
//

import SwiftUI

struct ImageLabelView: View {
    var icon: Icon?
    var iconSize: CGFloat = 40
    var text: String
    var font: Font = .body
    var color: Color = .primary

    var body: some View {
        HStack {
            icon.map { IconImage($0, iconSize: iconSize) }
            Text(text).font(.body).foregroundColor(color)
        }
    }
}
